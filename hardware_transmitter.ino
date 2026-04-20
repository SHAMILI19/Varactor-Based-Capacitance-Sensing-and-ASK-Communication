void setup() {
  Serial.begin(9600);
}

void loop() {
  int value = analogRead(A0); // 0–1023
  Serial.println(value);
  delay(50);
}
