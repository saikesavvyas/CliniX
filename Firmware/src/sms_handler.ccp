/* ---------------------------------------------------------
   ESP32: Read PLC D0 (M0 mirror) over Modbus RTU (RS485)
   and send SMS via GSM module (SIM800 / SIM900 family)
   ---------------------------------------------------------
   Hardware mapping used in this sketch (change if needed):
     - RS485 (MAX485) DI -> ESP32 TX2 (GPIO17)
     - RS485 (MAX485) RO -> ESP32 RX2 (GPIO16)
     - RS485 DE/RE -> ESP32 GPIO4 (drive HIGH to transmit)
     - GSM module TX -> ESP32 RX1 (GPIO26)
     - GSM module RX -> ESP32 TX1 (GPIO27)
   Modbus:
     - Slave ID = 1
     - D0 (address 0) = GSM alert bit (0/1)
     - Optional status regs D1..D4 at addresses 1..4
   --------------------------------------------------------- */

#include <ModbusMaster.h>
#include <HardwareSerial.h>

/////////////////////////////////
// CONFIGURATION - EDIT THESE //
/////////////////////////////////

// Modbus / RS485
#define MODBUS_SLAVE_ID  1
#define COIL_REG_D0_ADDR 0    // holding register address for D0 (your MOV mapped register)

// RS485 DE/RE control pin
const int RS485_DE_RE_PIN = 4;

// Serial ports (ESP32)
HardwareSerial ModbusSerial(2); // Serial2 used for RS485
HardwareSerial GsmSerial(1);    // Serial1 used for GSM

// Serial pins (change if you wire differently)
const int RS485_RX_PIN = 16; // ESP32 RX2 (to MAX485 RO)
const int RS485_TX_PIN = 17; // ESP32 TX2 (to MAX485 DI)
const int GSM_RX_PIN   = 26; // ESP32 RX1 (from GSM TX)
const int GSM_TX_PIN   = 27; // ESP32 TX1 (to GSM RX)

// GSM phone numbers (international format, comma separated)
const char* phoneNumbers[] = {
  "+91XXXXXXXXXX",   // primary
  "+91YYYYYYYYYY"    // secondary (add/delete as needed)
};
const size_t phoneCount = sizeof(phoneNumbers)/sizeof(phoneNumbers[0]);

// Anti spam & retries
const unsigned long SMS_COOLDOWN_MS = 30UL * 1000UL; // 30 seconds between SMS
const int SMS_MAX_RETRIES = 3;
const unsigned long POLL_INTERVAL_MS = 2000UL;       // 2s poll

/////////////////////////////////
// END CONFIGURATION          //
/////////////////////////////////

ModbusMaster node;
bool lastAlertState = false;
unsigned long lastSmsTime = 0;

/////////////////////////
// RS485 helper funcs  //
/////////////////////////

void preTransmission() {
  digitalWrite(RS485_DE_RE_PIN, HIGH); // enable driver
  delayMicroseconds(100);
}

void postTransmission() {
  digitalWrite(RS485_DE_RE_PIN, LOW);  // disable driver (enable receiver)
  delayMicroseconds(100);
}

/////////////////////////
// GSM helper functions
/////////////////////////

// Send a command to GSM and optionally read a short response (nonblocking)
void gsmSendCmd(const char* cmd, unsigned long waitMs = 500) {
  GsmSerial.print(cmd);
  GsmSerial.print("\r\n");
  delay(waitMs);
  // flush any response to Serial for debugging
  while (GsmSerial.available()) {
    char c = GsmSerial.read();
    Serial.write(c);
  }
}

bool gsmInit() {
  // Basic init sequence - you can expand to check "OK" responses properly
  Serial.println("GSM init...");
  gsmSendCmd("AT", 500);
  gsmSendCmd("ATE0", 200);       // disable echo
  gsmSendCmd("AT+CMGF=1", 500);  // text mode
  delay(500);
  return true;
}

bool sendSMSviaGSM(const char* number, const String &message) {
  // send in text mode - AT+CMGF=1 should be set
  Serial.printf("Sending SMS to %s\n", number);
  GsmSerial.print("AT+CMGS=\"");
  GsmSerial.print(number);
  GsmSerial.print("\"\r\n");
  delay(500);
  GsmSerial.print(message);
  delay(200);
  GsmSerial.write((uint8_t)26); // Ctrl+Z
  // wait for send confirmation
  unsigned long start = millis();
  bool ok = false;
  while (millis() - start < 10000) { // wait up to 10s for response
    if (GsmSerial.available()) {
      String resp = GsmSerial.readStringUntil('\n');
      resp.trim();
      Serial.println("GSM Resp: " + resp);
      if (resp.indexOf("OK") >= 0 || resp.indexOf("+CMGS:") >= 0) {
        ok = true;
        break;
      }
    }
  }
  return ok;
}

bool sendSMSToAll(const String &msg) {
  for (size_t i = 0; i < phoneCount; ++i) {
    bool sent = false;
    for (int attempt=0; attempt < SMS_MAX_RETRIES && !sent; ++attempt) {
      Serial.printf("Attempt %d to %s\n", attempt+1, phoneNumbers[i]);
      if (sendSMSviaGSM(phoneNumbers[i], msg)) {
        Serial.println("SMS sent OK");
        sent = true;
      } else {
        Serial.println("SMS send failed, retrying...");
        delay(1500);
      }
    }
    if (!sent) {
      Serial.printf("FAILED to send SMS to %s\n", phoneNumbers[i]);
      // continue to try other numbers even if one fails
    }
  }
  return true;
}

/////////////////////////
// Setup & Loop
/////////////////////////

void setup() {
  Serial.begin(115200);
  delay(200);

  pinMode(RS485_DE_RE_PIN, OUTPUT);
  digitalWrite(RS485_DE_RE_PIN, LOW); // start in receive mode

  // start Modbus serial (Serial2) - CRC modbus style
  ModbusSerial.begin(9600, SERIAL_8N1, RS485_RX_PIN, RS485_TX_PIN);
  node.begin(MODBUS_SLAVE_ID, ModbusSerial);
  node.preTransmission(preTransmission);
  node.postTransmission(postTransmission);

  // start GSM UART (Serial1)
  GsmSerial.begin(9600, SERIAL_8N1, GSM_RX_PIN, GSM_TX_PIN);
  delay(1000);
  gsmInit();

  Serial.println("System ready.");
}

void loop() {
  // Poll PLC D0
  static unsigned long lastPoll = 0;
  if (millis() - lastPoll < POLL_INTERVAL_MS) return;
  lastPoll = millis();

  uint8_t result = node.readHoldingRegisters(COIL_REG_D0_ADDR, 1);
  bool alertNow = false;
  if (result == node.ku8MBSuccess) {
    uint16_t reg = node.getResponseBuffer(0);
    alertNow = (reg != 0);
    Serial.printf("Read D0 = %u\n", reg);
  } else {
    Serial.print("Modbus read error: ");
    Serial.println(result);
    // optional: handle comm failure, increment failure counter
    // we do not change lastAlertState here
    return;
  }

  // Rising edge detection
  if (alertNow && !lastAlertState) {
    unsigned long sinceLast = millis() - lastSmsTime;
    if (sinceLast >= SMS_COOLDOWN_MS) {
      // optionally read status registers and add context
      String smsMsg = "ALERT: No power source available at Clinic.";
      // read other status registers (optional). Example addresses D1..D4:
      uint8_t r = node.readHoldingRegisters(1, 4);
      if (r == node.ku8MBSuccess) {
        uint16_t g = node.getResponseBuffer(0); // D1 Grid
        uint16_t s = node.getResponseBuffer(1); // D2 Solar
        uint16_t b = node.getResponseBuffer(2); // D3 Battery
        uint16_t gen = node.getResponseBuffer(3); // D4 Gen
        smsMsg += " Status[G,S,B,Gen]=" + String(g) + "," + String(s) + "," + String(b) + "," + String(gen);
      }
      // send SMS
      bool ok = sendSMSToAll(smsMsg);
      lastSmsTime = millis();
      if (!ok) {
        Serial.println("Warning: SMS send routine returned failure (but continued).");
      }
    } else {
      Serial.println("Alert suppressed due to cooldown");
    }
  }

  // falling edge: you may want to send recovery SMS
  if (!alertNow && lastAlertState) {
    // optional recovery SMS
    unsigned long sinceLast = millis() - lastSmsTime;
    if (sinceLast >= SMS_COOLDOWN_MS) {
      String smsMsg = "RECOVERY: Power source available at Clinic.";
      sendSMSToAll(smsMsg);
      lastSmsTime = millis();
    }
  }

  lastAlertState = alertNow;
}
