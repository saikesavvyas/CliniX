#include <Arduino.h>
#include "model_data.h"
#include "scaler.h"
#include "encoders.h"
#include "labels.h"

#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

// Allocate tensor arena (memory for the model)
constexpr int kTensorArenaSize = 60 * 1024;   // increase if model is bigger
uint8_t tensor_arena[kTensorArenaSize];

// Global vars
const tflite::Model* model = nullptr;
tflite::MicroInterpreter* interpreter = nullptr;
TfLiteTensor* input = nullptr;
TfLiteTensor* output = nullptr;

void setup() {
  Serial.begin(115200);
  delay(2000);
  Serial.println("\n🔌 Booting ESP32 for inference...");

  // Load the TFLite model from model_data.h
  model = tflite::GetModel(model_tflite);
  if (model->version() != TFLITE_SCHEMA_VERSION) {
    Serial.printf("❌ Model schema mismatch! Expected %d, got %d\n",
                  TFLITE_SCHEMA_VERSION, model->version());
    while (true);
  }

  // AllOpsResolver gives access to all ops (can optimize later)
  static tflite::AllOpsResolver resolver;

  // Build the interpreter
  static tflite::MicroInterpreter static_interpreter(
      model, resolver, tensor_arena, kTensorArenaSize);
  interpreter = &static_interpreter;

  // Allocate tensors
  if (interpreter->AllocateTensors() != kTfLiteOk) {
    Serial.println("❌ AllocateTensors() failed!");
    while (true);
  }

  // Input/output tensors
  input = interpreter->input(0);
  output = interpreter->output(0);

  Serial.println("✅ Model loaded and ready.");
}

void loop() {
  // Example manual input (replace with obtained values)
  float features[9] = {
    75.0,     // BatteryLevel
    32.0,     // Temperature
    230.0,    // Voltage
    5.2,      // Current
    (float)encode_DailyPatients("Medium"),
    (float)encode_Criticality("High"),
    (float)encode_WeatherCondition("Sunny"),
    (float)encode_GridStatus("Available"),
    (float)encode_TimeOfDay("Morning")
  };

  // ==========================
  // Apply StandardScaler
  // ==========================
  for (int i = 0; i < 9; i++) {
    features[i] = (features[i] - scaler_mean[i]) / scaler_scale[i];
  }

  // ==========================
  // Quantize input → int8
  // ==========================
  for (int i = 0; i < 9; i++) {
    int8_t q = (int8_t)round(features[i] / input->params.scale + input->params.zero_point);
    input->data.int8[i] = q;
  }

  // ==========================
  // Run inference
  // ==========================
  if (interpreter->Invoke() != kTfLiteOk) {
    Serial.println("❌ Invoke failed!");
    delay(5000);
    return;
  }

  // ==========================
  // Get prediction
  // ==========================
  int best_index = 0;
  int8_t max_val = output->data.int8[0];
  for (int i = 1; i < output->dims->data[1]; i++) {
    if (output->data.int8[i] > max_val) {
      max_val = output->data.int8[i];
      best_index = i;
    }
  }

  // Print result
  Serial.print("🔮 Predicted SourceOrder → ");
  Serial.println(y_labels[best_index]);

  delay(5000); // Run every 5 seconds
}
