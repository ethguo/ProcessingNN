Cell[][] cells;
int gridWidth = 20;
int gridHeight = 20;
float cellWidth, cellHeight;
float padding = 20;
float framerate = 1/2.0;

void setup(){
  size(800, 800);
  frameRate(framerate);

  colorMode(HSB, 2*PI, 1.0, 1.0);

  cells = new Cell[gridHeight][gridWidth];
  cellWidth = (width-2*padding)/gridWidth;
  cellHeight = (height-2*padding)/gridHeight;

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
  Cell[][] nextCells = new Cell[gridHeight][gridWidth];

  for (int j = 0; j < gridWidth; j++) {
    for (int i = 0; i < gridHeight; i++) {
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

  for (int i = 0; i < gridHeight; i++) {
    for (int j = 0; j < gridWidth; j++) {
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
  
  for (int i = 0; i < gridHeight; i++) {
    for (int j = 0; j < gridWidth; j++) {
      float x = padding + j*cellWidth;

      fill(cells[i][j]);
      
      rect(x, y, cellWidth, cellHeight);
    }
    y += cellHeight;
  }
}

void initializeCells() {
  for (int i = 0; i < gridHeight; i++) {
    float state = round(random(0, 1));
    cells[i][0] = new Cell(state);
  }
}

 