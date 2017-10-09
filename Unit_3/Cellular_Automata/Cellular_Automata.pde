/* PARAMETERS */
int numCols = 20;
int numRows = 15;
float padding = 0;
float bottomPadding = 60;
int outlineWeight = 4;
float framerate = 1;
boolean showText = true;
boolean coloredFill = false;
/* END OF PARAMETERS */

Cell[][] cells;
float cellWidth, cellHeight;
int iterationRow;

DummyCell dummyCell;

void setup() {
  size(1200, 960);
  frameRate(framerate);
  // colorMode(HSB, 2*PI, 1.0, 1.0);

  // Drawing settings
  colorMode(RGB, 1.0, 1.0, 1.0);
  strokeWeight(outlineWeight);
  textFont(createFont("Consolas", 11));

  cellWidth = (width - 2 * padding) / numCols;
  cellHeight = (height - 2 * padding - bottomPadding) / numRows;

  dummyCell = new DummyCell(); // Initialize singleton DummyCell
  iterationRow = 1;

  initializeCells();

  background(0);
}

void draw() {
  print(iterationRow);

  updateCells();
  drawCells();

  iterationRow += 1;
  if (iterationRow == numRows) {
    noLoop();
  }

  println();
}

void updateCells() {
  for (int col = 0; col < numCols; col++) {
    Cell[] neighbours = getNeighbours(iterationRow, col);
    cells[iterationRow][col].forward(neighbours);
  }
}

Cell[] getNeighbours(int row, int col) {
  Cell[] neighbours = new Cell[3];

  try {
    neighbours[0] = cells[row - 1][col - 1];
  }
  catch (ArrayIndexOutOfBoundsException e) {
    neighbours[0] = dummyCell;
  }

  neighbours[1] = cells[row - 1][col];

  try {
    neighbours[2] = cells[row - 1][col + 1];
  }
  catch (ArrayIndexOutOfBoundsException e) {
    neighbours[2] = dummyCell;
  }

  return neighbours;
}

void drawCells() {
  color strokeColor, fillColor;
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      float x = padding + col * cellWidth;
      float y = padding + row * cellHeight;

      strokeColor = cells[row][col].getStrokeColor();
      if (coloredFill)
        fillColor = cells[row][col].getFillColor();
      else
        fillColor = color(cells[row][col].getActivation());
      stroke(strokeColor);
      fill(fillColor);

      rect(x, y, cellWidth - outlineWeight, cellHeight - outlineWeight);

      if (showText) {
        fill(round(1 - brightness(fillColor))); // Pick either black or white, for maximum contrast

        String a  = " A:" + nfs(cells[row][col].getActivation(), 1, 2);
        text(a,  x + outlineWeight, y + 10 + outlineWeight);
        if (row > 0) {
          String r0 = "R0:" + nfs(cells[row][col].getResponse(0), 1, 2);
          String r1 = "R1:" + nfs(cells[row][col].getResponse(1), 1, 2);
          String r2 = "R2:" + nfs(cells[row][col].getResponse(2), 1, 2);
          text(r0, x + outlineWeight, y + 20 + outlineWeight);
          text(r1, x + outlineWeight, y + 30 + outlineWeight);
          text(r2, x + outlineWeight, y + 40 + outlineWeight);
        }
      }
    }
  }
}

void initializeCells() {
  cells = new Cell[numRows][numCols];

  // Initialize stimuli (in row 0)
  for (int col = 0; col < numCols; col++) {
    float state = round(random(0, 1));
    cells[0][col] = new Cell(state);
  }

  // Initialize neurons
  for (int row = 1; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      cells[row][col] = new Neuron();
    }
  }
}

float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}
