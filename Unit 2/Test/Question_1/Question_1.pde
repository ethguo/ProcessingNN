
int numDots = 8000;
int dotSize = 2;
int xC = 400;
int yC = 400;
int R = 300;
int r = 150;

int[] xVal = new int[numDots];
int[] yVal = new int[numDots];

void setup() {
  size(800, 800);
  background(0);
  
  for (int i = 0; i < numDots; i++) {
    int xRand = (int) random(0, 800);
    int yRand = (int) random(0, 800);
    xVal[i] = xRand;
    yVal[i] = yRand;
  }
  
  drawPoints();
}

float getDistance(int x1, int y1, int x2, int y2) {
  float dist = sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
  return dist;
}

void drawPoints() {
  for (int i = 0; i < xVal.length; i++) {
    float d = getDistance(xVal[i], yVal[i], xC, yC);
    
    int dotColour;
    if (d < r && xVal[i] < 400) {
      dotColour = #FF0000;
    }
    else if (d < r && xVal[i] >= 400) {
      dotColour = #00FF00;
    }
    else if (d < R || d > 1.5*R) {
      dotColour = #0000FF;
    }
    else {
      dotColour = #FFFFFF;
    }
    
    stroke(dotColour);
    fill(dotColour);
    ellipse(xVal[i], yVal[i], dotSize, dotSize);
  }
}