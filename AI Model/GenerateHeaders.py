# generate_headers.py
import pickle, json

# Load encoders
encoders = pickle.load(open("encoders.pkl", "rb"))
scaler = pickle.load(open("scaler.pkl", "rb"))
y_encoder = pickle.load(open("y_encoder.pkl", "rb"))

# ======================
# Export scaler.h
# ======================
with open("scaler.h", "w", encoding="utf-8") as f:
    f.write("// Auto-generated scaler parameters\n")
    f.write(f"const float scaler_mean[{len(scaler.mean_)}] = {{ {', '.join(map(str, scaler.mean_))} }};\n")
    f.write(f"const float scaler_scale[{len(scaler.scale_)}] = {{ {', '.join(map(str, scaler.scale_))} }};\n")

# ======================
# Export labels.h
# ======================
with open("labels.h", "w", encoding="utf-8") as f:
    f.write("// Auto-generated class labels\n")
    f.write(f"const char* y_labels[{len(y_encoder.classes_)}] = {{\n")
    for c in y_encoder.classes_:
        safe = c.encode("ascii", errors="replace").decode()
        f.write(f'  "{safe}",\n')
    f.write("};\n")

# ======================
# Export encoders.h
# ======================
with open("encoders.h", "w", encoding="utf-8") as f:
    f.write("// Auto-generated categorical encoders\n")
    for col, le in encoders.items():
        f.write(f"int encode_{col}(const char* s) {{\n")
        for i, c in enumerate(le.classes_):
            safe = c.encode("ascii", errors="replace").decode()
            f.write(f'  if (strcmp(s, "{safe}") == 0) return {i};\n')
        f.write("  return -1; // unknown\n")
        f.write("}\n\n")
