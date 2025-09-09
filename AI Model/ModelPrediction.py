import numpy as np
import joblib
import tensorflow as tf
import pandas as pd

# ================================
# Load Model, Scaler, Encoders
# ================================
model = tf.keras.models.load_model("Power_Source_Model.h5") #GIVE PATH NAMES AS REQUIRED

scaler = joblib.load("scaler.pkl")
encoders = joblib.load("encoders.pkl")
y_encoder = joblib.load("y_encoder.pkl")

# ================================
# Example Input (To check the prediction of the model)
# 9 input columns in order
# Change input values if required
# ================================
input_data = {
    "DailyPatients" : "High",
    "Criticality" : "High",
    "WeatherCondition" : "Rainy",
    "BatteryLevel" : 62,
    "GridStatus" : "Available",
    "TimeOfDay" : "Morning",
    "Temperature" : 22,
    "Voltage" : 242,
    "Current" : 10
}


# ================================
# Preprocess Input
# ================================
# Convert to DataFrame
df_input = pd.DataFrame([input_data])

# Encode categorical columns using saved encoders
for col in df_input.columns:
    if col in encoders:
        df_input[col] = encoders[col].transform(df_input[col])

# Scale numerical features
X_scaled = scaler.transform(df_input)

# ================================
# Prediction
# ================================
pred = model.predict(X_scaled)
predicted_class = np.argmax(pred, axis=1)
predicted_label = y_encoder.inverse_transform(predicted_class)

print("🔮 Predicted Source Order:", predicted_label[0])
