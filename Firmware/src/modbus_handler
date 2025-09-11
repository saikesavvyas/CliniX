#include <ModbusMaster.h>
#include <HardwareSerial.h>

// Create Modbus object
ModbusMaster node;

// RS485 control pin
#define MAX485_DE 4
#define MAX485_RE 4

// GSM serial
HardwareSerial gsmSerial(2); // Use UART2
#define GSM_RX 16
#define GSM_TX 17

// Function to control DE/RE pin
void preTransmission() {
  digitalWrite(MAX485_DE, 1);
  digitalWrite(MAX485_RE, 1);
}

void postTransmission() {
  digitalWrite(MAX485_DE, 0);
  digitalWrite(MAX485_RE, 0);
}

void setup() {
  Serial.begin(115200);

  // RS485 setup
  pinMode(MAX485_DE, OUTPUT);
  pinMode(MAX485_RE, OUTPUT);
  postTransmission();

  // Modbus init
  node.begin(1, Serial1);   // Slave ID = 1, Serial1 for RS485
  Serial1.begin(9600, SERIAL_8N1, 26, 25); // RX=26, TX=25
  node.preTransmission(preTransmission);
  node.postTransmission(postTransmission);

  // GSM init
  gsmSerial.begin(9600, SERIAL_8N1, GSM_RX, GSM_TX);
  delay(1000);
  sendSMS("System booted. ESP32 online.");
}

void loop() {
  uint8_t result;
  uint16_t data;

  // Read D0 register (Alert Flag)
  result = node.readHoldingRegisters(0, 1); // D0 = Register 0
  if (result == node.ku8MBSuccess) {
    data = node.getResponseBuffer(0);
    Serial.print("Alert Register D0: ");
    Serial.println(data);

    if (data == 1) {
      sendSMS("[CLINIC POWER] CRITICAL: All sources down! Manual intervention required!
");
    }
  } else {
    Serial.println("Failed to read D0");
  }

  // Read Status Registers (Example: D1=Grid, D2=Solar, D3=Battery, D4=Generator)
  result = node.readHoldingRegisters(1, 4);
  if (result == node.ku8MBSuccess) {
    Serial.print("Grid: "); Serial.println(node.getResponseBuffer(0));
    Serial.print("Solar: "); Serial.println(node.getResponseBuffer(1));
    Serial.print("Battery: "); Serial.println(node.getResponseBuffer(2));
    Serial.print("Generator: "); Serial.println(node.getResponseBuffer(3));
  }

  delay(5000); // Every 5 seconds
}

// GSM Send SMS Function
void sendSMS(String message) {
  gsmSerial.println("AT+CMGF=1");  
  delay(1000);
  gsmSerial.println("AT+CMGS=\"+91XXXXXXXXXX\""); // Replace with phone number
  delay(1000);
  gsmSerial.print(message);
  delay(1000);
  gsmSerial.write(26); // CTRL+Z to send
  delay(5000);
}



#include <ModbusMaster.h>

ModbusMaster node;
#define RS485_DE_RE 25  

void preTransmission() {
  digitalWrite(RS485_DE_RE, 1);
}
void postTransmission() {
  digitalWrite(RS485_DE_RE, 0);
}

void setup() {
  Serial.begin(115200);

  pinMode(RS485_DE_RE, OUTPUT);
  digitalWrite(RS485_DE_RE, 0);

  Serial2.begin(9600, SERIAL_8N1, 16, 17); // RX=16, TX=17
  node.begin(1, Serial2); // PLC slave ID = 1
  node.preTransmission(preTransmission);
  node.postTransmission(postTransmission);

  Serial.println("ESP32 Modbus RTU Master - WRITE Mode");
}

void loop() {
  uint8_t result;

  // Example AI prediction (replace with your AI output variable)
  uint16_t AI_command = 2;  // e.g., 1=Battery, 2=Generator, 3=Grid

  // Write AI command into PLC register 200
  result = node.writeSingleRegister(200, AI_command);

  if (result == node.ku8MBSuccess) {
    Serial.print("AI Command ("); Serial.print(AI_command); Serial.println(") sent successfully.");
  } else {
    Serial.print("Failed to write, error: ");
    Serial.println(result, HEX);
  }

  delay(5000);
}
