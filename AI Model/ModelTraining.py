# train_model.py
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
import tensorflow as tf
from tensorflow.keras import layers, models
import pickle

# ======================
# Load dataset
# ======================
df = pd.read_excel("ClinicDataset4.xlsx", sheet_name="Sheet1")

input_cols = df.columns[:-1].tolist()
target_col = df.columns[-1]

X = df[input_cols].copy()
y = df[target_col].copy()

# ======================
# Encode categorical columns
# ======================
encoders = {}
for col in X.select_dtypes(include=["object", "category"]).columns:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col].astype(str))
    encoders[col] = le

# Save encoders
with open("encoders.pkl", "wb") as f:
    pickle.dump(encoders, f)

# ======================
# Encode target
# ======================
y_encoder = LabelEncoder()
y = y_encoder.fit_transform(y)

with open("y_encoder.pkl", "wb") as f:
    pickle.dump(y_encoder, f)

# ======================
# Scale numeric features
# ======================
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

with open("scaler.pkl", "wb") as f:
    pickle.dump(scaler, f)

# ======================
# Train/test split
# ======================
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, train_size=1200, test_size=300, stratify=y, random_state=42
)

# ======================
# Build model
# ======================
model = models.Sequential([
    layers.Input(shape=(X_train.shape[1],)),
    layers.Dense(32, activation="relu"),
    layers.Dense(16, activation="relu"),
    layers.Dense(len(np.unique(y)), activation="softmax")
])

model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])
model.fit(X_train, y_train, epochs=100, batch_size=16, validation_data=(X_test, y_test))

# ======================
# Save model
# ======================
model.save("CliniX_model.h5")

# ======================
# Convert to quantized TFLite
# ======================
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.int8]
converter.inference_input_type = tf.int8
converter.inference_output_type = tf.int8

def representative_data_gen():
    for i in range(100):
        yield [X_train[i:i+1].astype(np.float32)]
converter.representative_dataset = representative_data_gen

tflite_model = converter.convert()
open("CliniX_model_int8.tflite", "wb").write(tflite_model)

# ======================
# Convert .tflite to .h
# ======================
b = open("CliniX_model_int8.tflite", "rb").read()
arr = ", ".join(str(x) for x in b)
h = f"const unsigned char model_tflite[] = {{{arr}}};\nconst unsigned int model_tflite_len = {len(b)};\n"
open("model_data.h", "w", encoding="utf-8").write(h)
