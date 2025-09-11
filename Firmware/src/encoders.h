// Auto-generated categorical encoders
int encode_DailyPatients(const char* s) {
  if (strcmp(s, "High") == 0) return 0;
  if (strcmp(s, "Low") == 0) return 1;
  if (strcmp(s, "Medium") == 0) return 2;
  return -1; // unknown
}

int encode_Criticality(const char* s) {
  if (strcmp(s, "High") == 0) return 0;
  if (strcmp(s, "Low") == 0) return 1;
  if (strcmp(s, "Medium") == 0) return 2;
  return -1; // unknown
}

int encode_WeatherCondition(const char* s) {
  if (strcmp(s, "Cloudy") == 0) return 0;
  if (strcmp(s, "Rainy") == 0) return 1;
  if (strcmp(s, "Sunny") == 0) return 2;
  return -1; // unknown
}

int encode_GridStatus(const char* s) {
  if (strcmp(s, "Available") == 0) return 0;
  if (strcmp(s, "Unavailable") == 0) return 1;
  return -1; // unknown
}

int encode_TimeOfDay(const char* s) {
  if (strcmp(s, "Afternoon") == 0) return 0;
  if (strcmp(s, "Morning") == 0) return 1;
  if (strcmp(s, "Night") == 0) return 2;
  return -1; // unknown
}

