import hypermedia.video.*;
import processing.serial.*;        

OpenCV opencv;
Serial serial;

boolean remember = false;

float updateFrames;
float updateCounter01;

color white = color(255);

float pixelBrightness;
int servoWrite;

void setup() {
  size(640, 480);
  opencv = new OpenCV( this );
  opencv.capture( width, height );

  println(Serial.list());
  serial = new Serial(this, Serial.list()[0], 9600);
}

void draw() {

  opencv.read();

  if ((millis() - updateFrames) > 11000) {
    opencv.remember();
    remember = true;
    updateFrames = millis();
  }

  if ( remember ) opencv.absDiff();
  image( opencv.image(), 0, 0 );

  int threshold = 10;
  int numPixels = width * height;
  int whitecount = 0;

  loadPixels();

  for (int i = 0; i < numPixels; i++) {
    pixelBrightness = brightness(pixels[i]);
    if (pixelBrightness > threshold) {
      whitecount++;
    }
  }


  updatePixels();

  if ((millis() - updateCounter01) > 5000) {
    
    println("white pixels value: " + whitecount);
    
    servoWrite = whitecount / 2000;

    println("servo angle: " + servoWrite);

    serial.write(servoWrite);

    updateCounter01 = millis();
  }
}
