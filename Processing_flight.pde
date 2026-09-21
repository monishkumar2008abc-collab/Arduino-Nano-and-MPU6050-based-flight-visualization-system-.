import processing.serial.*;

Serial myPort;

float roll = 0;
float pitch = 0;

void setup() {
  size(900, 700, P3D);

  println(Serial.list());

  // CHANGE 0 to the correct COM-port index
  myPort = new Serial(this, Serial.list()[0], 115200);

  myPort.bufferUntil('\n');

  smooth();
}

void draw() {

  background(30);

  // Lighting
  lights();

  // Title
  fill(255);
  textSize(24);
  text("MPU6050 Flight Visualization", 25, 40);

  // 3D aircraft
  pushMatrix();

  translate(width / 2, height / 2, 0);

  // Pitch
  rotateX(radians(pitch));

  // Roll
  rotateZ(radians(roll));

  drawAircraft();

  popMatrix();

  // Display values
  fill(255);
  textSize(18);

  text("Roll  : " + nf(roll, 1, 2) + "°", 25, height - 70);
  text("Pitch : " + nf(pitch, 1, 2) + "°", 25, height - 40);
}


// ===============================
// DRAW AIRCRAFT
// ===============================

void drawAircraft() {

  // Aircraft body
  pushMatrix();

  fill(160);
  box(260, 45, 45);

  popMatrix();


  // ===============================
  // MAIN WINGS
  // ===============================

  pushMatrix();

  fill(100);

  translate(20, 0, 0);

  box(50, 12, 350);

  popMatrix();


  // ===============================
  // TAIL WINGS
  // ===============================

  pushMatrix();

  fill(120);

  translate(-100, 0, 0);

  box(30, 10, 150);

  popMatrix();


  // ===============================
  // VERTICAL TAIL
  // ===============================

  pushMatrix();

  fill(140);

  translate(-100, -35, 0);

  box(35, 70, 12);

  popMatrix();


  // ===============================
  // NOSE
  // ===============================

  // A simple box is used instead of cone()
  pushMatrix();

  fill(190);

  translate(150, 0, 0);

  box(80, 35, 35);

  popMatrix();


  // ===============================
  // COCKPIT
  // ===============================

  pushMatrix();

  fill(60);

  translate(40, -30, 0);

  box(60, 20, 35);

  popMatrix();


  // ===============================
  // CENTER MARKER
  // ===============================

  pushMatrix();

  fill(255, 0, 0);

  sphere(8);

  popMatrix();
}


// ===============================
// SERIAL DATA
// ===============================

void serialEvent(Serial port) {

  String data = port.readStringUntil('\n');

  if (data != null) {

    data = trim(data);

    String[] values = split(data, ',');

    if (values.length == 2) {

      try {

        float newRoll = float(values[0]);
        float newPitch = float(values[1]);

        // Smooth movement
        roll = lerp(roll, newRoll, 0.15);
        pitch = lerp(pitch, newPitch, 0.15);

      }
      catch(Exception e) {

        println("Invalid data: " + data);
      }
    }
  }
}
