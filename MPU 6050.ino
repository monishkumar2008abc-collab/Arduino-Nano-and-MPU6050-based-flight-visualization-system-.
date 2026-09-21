#include <Wire.h>

#define MPU 0x68

float roll = 0;
float pitch = 0;

unsigned long previousTime;

void setup() {
  Serial.begin(115200);
  Wire.begin();

  // Wake MPU6050
  Wire.beginTransmission(MPU);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission();

  previousTime = millis();
}

void loop() {

  Wire.beginTransmission(MPU);
  Wire.write(0x3B);
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 14, true);

  int16_t ax = Wire.read() << 8 | Wire.read();
  int16_t ay = Wire.read() << 8 | Wire.read();
  int16_t az = Wire.read() << 8 | Wire.read();

  // Skip temperature
  Wire.read();
  Wire.read();

  int16_t gx = Wire.read() << 8 | Wire.read();
  int16_t gy = Wire.read() << 8 | Wire.read();
  int16_t gz = Wire.read() << 8 | Wire.read();

  // Accelerometer angles
  float accelRoll = atan2(ay, az) * 180.0 / PI;

  float accelPitch = atan2(
    -ax,
    sqrt((float)ay * ay + (float)az * az)
  ) * 180.0 / PI;

  // Time
  unsigned long currentTime = millis();
  float dt = (currentTime - previousTime) / 1000.0;
  previousTime = currentTime;

  // Gyroscope conversion
  float gyroX = gx / 131.0;
  float gyroY = gy / 131.0;

  // Complementary filter
  roll = 0.98 * (roll + gyroX * dt) + 0.02 * accelRoll;
  pitch = 0.98 * (pitch + gyroY * dt) + 0.02 * accelPitch;

  // Send to Processing
  Serial.print(roll);
  Serial.print(",");
  Serial.println(pitch);

  delay(10);
}
