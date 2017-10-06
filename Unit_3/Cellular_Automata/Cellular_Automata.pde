color[][] cells;
int n = 20;
float cellSize;
float padding = 20;
float framerate = 1/2.0;

void setup(){
  size(800, 800);
  frameRate(framerate);

  colorMode(HSB, 2*PI, 1.0, 1.0);

  cells = new color[n][n];
  cellSize = (width-2*padding)/n;

  initializeCells();
  drawCells();

  background(0);
}

void draw() {
  // background(2.0/3 * PI, 1.0, 1.0);

  updateCells();
  drawCells();
}

void updateCells() {
  color[][] nextCells = new color[n][n];

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      nextCells[i][j] = updateCell(i, j);
    }
  }
  

  // int liveNeighbours;
  //     liveNeighbours = countLiveNeighbours(i, j);

  //     if (cells[i][j] == 1) {
  //       if (liveNeighbours == 2 || liveNeighbours == 3)
  //         nextCells[i][j] = 1;
  //       else
  //         nextCells[i][j] = 0;
  //     }
  //     else {
  //       if (liveNeighbours == 3)
  //         nextCells[i][j] = 1;
  //       else
  //         nextCells[i][j] = 0;
  //     }
  //   }
  // }

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      cells[i][j] = nextCells[i][j];
    }
  }
}

color updateCell(int i, int j) {
  color neighbour;
  PVector hueAverage = new PVector();
  float saturationSum = 0;
  float brightnessSum = 0;
  float nAverage = 0;
  // float nextSaturation = 0;
  // float nextBrightness = 0;
  float neighbourAngle, neighbourHue, neighbourSaturation, angleDifference, weight;
  for (int deltai = -1; deltai <= 1; deltai++) {
    for (int deltaj = -1; deltaj <= 1; deltaj++) {
      if (deltai != 0 || deltaj != 0) {
        try {
          neighbour = cells[i + deltai][j + deltaj];
          neighbourAngle = atan2(-deltai, deltaj);
          neighbourHue = hue(neighbour);

          angleDifference = neighbourAngle - neighbourHue;
          if (angleDifference > PI)
            angleDifference -= 2*PI;
          else if (angleDifference < -PI)
            angleDifference += 2*PI;

          // weight = 1 - angleDifference / PI;

          weight = saturation(neighbour);

          if (weight != 0) {
            nAverage += 1;
            hueAverage.add(PVector.fromAngle(neighbourHue));
            saturationSum += weight;
            // brightnessSum += weight;
          }

        }
        catch (ArrayIndexOutOfBoundsException e) { }
      }
    }
  }
  float nextHue = hueAverage.heading();
  return color(nextHue, saturationSum/nAverage, 1.0);
}

void drawCells() {
  float y = padding;

  strokeWeight(2);
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = padding + j*cellSize;

      fill(cells[i][j]);
      color c2 = color((hue(cells[i][j]) + 1) % 2*PI, 1.0, 1.0);
      stroke(c2);

      rect(x, y, cellSize-4, cellSize-4);
    }
    y += cellSize;
  }
}

void initializeCells() {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = random(0, 1);
      if (x < 0.01) {
        float hue = random(0,2*PI);

        cells[i][j] = color(hue, 1.0, 1.0);
      }
      else {
        cells[i][j] = color(0);
      }
    }
  }
}

 