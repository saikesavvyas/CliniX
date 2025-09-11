import pickle
import numpy as np
import tensorflow as tf
import pandas as pd

# ======================
# Load model and tools
# ======================
model = tf.keras.models.load_model("CliniX_model.h5")

with open("encoders.pkl", "rb") as f:
    encoders = pickle.load(f)

with open("y_encoder.pkl", "rb") as f:
    y_encoder = pickle.load(f)

with open("scaler.pkl", "rb") as f:
    scaler = pickle.load(f)

# ======================
# Define manual input (example values — replace as needed)
# ======================
manual_input = {
    "DailyPatients": "High",
    "Criticality": "Medium",
    "WeatherCondition": "Sunny",
    "BatteryLevel": 75,
    "GridStatus": "Available",
    "TimeOfDay": "Morning",
    "Temperature": 26,
    "Voltage": 235,
    "Current": 12
}

# ======================
# Prepare input
# ======================
df_input = pd.DataFrame([manual_input])

# Apply label encoding on categorical columns
for col, le in encoders.items():
    if col in df_input.columns:
        df_input[col] = le.transform(df_input[col].astype(str))

# Convert to numpy
X_input = df_input.values.astype(float)

# Apply scaling
X_scaled = scaler.transform(X_input)

# ======================
# Run prediction
# ======================
pred_probs = model.predict(X_scaled)
pred_class = np.argmax(pred_probs, axis=1)[0]
pred_label = y_encoder.inverse_transform([pred_class])[0]

# ======================
# Output result
# ======================
print("Input values:", manual_input)
print("Predicted SourceOrder:", pred_label)
