/* PARAMETERS */
int numCols = 20;
int numRows = 20;
float padding = 20;
float framerate = 1;
/* END OF PARAMETERS */

Cell[][] cells;
float cellWidth, cellHeight;
int iterationRow;

DummyCell dummyCell;

void setup() {
  size(800, 800);
  frameRate(framerate);
  // colorMode(HSB, 2*PI, 1.0, 1.0);
  colorMode(RGB, 1.0, 1.0, 1.0);

  cellWidth = (width - 2 * padding) / numCols;
  cellHeight = (height - 2 * padding) / numRows;

  dummyCell = new DummyCell(); // Initialize singleton DummyCell
  iterationRow = 1;

  initializeCells();

  background(0);
}

void draw() {
  print(iterationRow);
  println();
  print(cells[1][1]); print(" ");
  print(cells[1][1].getActivation()); println();

  updateCells();

  print(cells[1][1]); print(" ");
  print(cells[1][1].getActivation()); println();

  drawCells();

  print(cells[1][1]); print(" ");
  print(cells[1][1].getActivation()); println();

  iterationRow += 1;

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
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      float x = padding + col * cellWidth;
      float y = padding + row * cellHeight;

      if (row == 1) print(cells[row][col].activation);

      stroke(cells[row][col].getStrokeColor());
      fill(cells[row][col].getFillColor());


      rect(x, y, cellWidth, cellHeight);
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
