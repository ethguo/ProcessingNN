// PARAMETERS
float scale = 200;
float virtualFrames = 20;
float deltaT = 0.001;

//GLOBAL VARIABLES
float xCenter, yCenter, t, x1, y1, z1, x2, y2, z2;


void setup(){
  size(800, 800, P3D);
  background(0);
  xCenter = width/2;
  yCenter = height/2;
  x1 = 0;
  y1 = 0;
  z1 = 0;
}

void draw() {
  lights();
  camera();
  action();
}

void camera() {
  translate(width/2, height/2, 0);

  ortho(-width/2.0, width/2.0, -height/2.0, height/2.0);
  
  rotateX(PI/2 - mouseY/float(width) * PI);
  rotateY(mouseX/float(height) * 2*PI);
}

void action() {
  background(0);
  stroke(255);

  t = 0;

  while (t < 12*PI) {
    x2 = pow(sin(7 * t), 3);
    y2 = sin(6 * t);
    z2 = sin(5 * t);

    x2 *= scale;
    y2 *= scale;
    z2 *= scale;
    
    line(x1, y1, z1, x2, y2, z2);
    
    x1 = x2;
    y1 = y2;
    z1 = z2;
    t += deltaT;
  }
}