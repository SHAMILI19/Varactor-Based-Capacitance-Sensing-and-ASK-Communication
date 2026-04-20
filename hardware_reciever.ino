int pwmPin = 9;
int val = 0;
void setup() {
  Serial.begin(9600);
  pinMode(pwmPin, OUTPUT);
}

void loop() {
  if (Serial.available()) {
    int val = Serial.parseInt();

    int pwm = map(val, 0, 1023, 0, 255);
    analogWrite(pwmPin, pwm);

    Serial.print("Received: ");
    Serial.print(val);
    Serial.print("  PWM: ");
    Serial.println(pwm);
  }
}
