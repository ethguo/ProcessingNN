// PARAMETERS
float scale = 100;
float virtualFrames = 20;
float deltaT = 0.001;

//GLOBAL VARIABLES
float xCenter, yCenter, t, x1, y1, x2, y2;


//MAIN PROGRAM
void setup(){
  size(800, 800);
  background(0);
  xCenter = width/2;
  yCenter = height/2;
  x1 = xCenter;
  y1 = yCenter;
}

//DRAW() GETS CALLED ~30 TIMES PER SECOND AFTER SETUP() FINISHES 
void draw() {
  if (t < 12*PI) {
    for (int i = 0; i < virtualFrames; i++) { 
      
      x2 =  sin(t) * (exp(cos(t)) - 2*cos(4*t) - pow(sin(t/12), 5)) * scale + xCenter;
      y2 = -cos(t) * (exp(cos(t)) - 2*cos(4*t) - pow(sin(t/12), 5)) * scale + yCenter;
      
      stroke(255);
      
      line(x1, y1, x2, y2);
      
      x1 = x2;
      y1 = y2;
      t += deltaT;
    }
  }
}