import pandas as pd
import numpy as np
import joblib   # for saving encoders and scalers
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.callbacks import EarlyStopping

# ==========================
# 1. Load Dataset
# ==========================
data = pd.read_excel(<MENTION YOUR DATASET PATH HERE>)

# Features (X) and Labels (y)
X = data.iloc[:, :-1]   # all features
y = data.iloc[:, -1]    # output (SourceOrder)

# ==========================
# 2. Encode Categorical Features
# ==========================
encoders = {}
for col in X.columns:
    if X[col].dtype == 'object':
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col])
        encoders[col] = le

# Save encoders
joblib.dump(encoders, "encoders.pkl")

# Encode output labels
y_encoder = LabelEncoder()
y = y_encoder.fit_transform(y)
y = to_categorical(y)

# Save output encoder
joblib.dump(y_encoder,"y_encoder.pkl")

# ==========================
# 3. Train/Test Split
# ==========================
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scale numerical features
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test  = scaler.transform(X_test)

# Save scaler
joblib.dump(scaler, "scaler.pkl")

# ==========================
# 4. Build Neural Network
# ==========================
model = Sequential([
    Dense(64, activation='relu', input_shape=(X_train.shape[1],)),
    Dropout(0.3),
    Dense(32, activation='relu'),
    Dropout(0.2),
    Dense(y.shape[1], activation='softmax')
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# ==========================
# 5. Train Model
# ==========================
es = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)

history = model.fit(
    X_train, y_train,
    validation_data=(X_test, y_test),
    epochs=100,
    batch_size=16,
    callbacks=[es],
    verbose=1
)

# ==========================
# 6. Evaluate Model
# ==========================
loss, acc = model.evaluate(X_test, y_test, verbose=0)
print(f"✅ Test Accuracy: {acc*100:.2f}%")

# ==========================
# 7. Save Model
# ==========================
model.save("Power_Source_Model.h5")
print("💾 Model saved as Power_Source_Model.h5")
print("Encoders and Scalers are also saved.")
