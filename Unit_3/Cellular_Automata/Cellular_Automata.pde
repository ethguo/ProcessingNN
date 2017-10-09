/* PARAMETERS */
int numCols = 20;
int numRows = 5;
float padding = 0;
float bottomPadding = 100;
int outlineWeight = 4;
float framerate = 2;
boolean showText = true;
boolean coloredFill = true;
float trainingRate = 3;
/* END OF PARAMETERS */

Cell[][] cells;
float cellWidth, cellHeight;
int iterationRow, dataItem;
DummyCell dummyCell;

int f = 1;

void setup() {
  size(1200, 600);
  frameRate(framerate);

  // Drawing settings
  colorMode(RGB, 1.0, 1.0, 1.0);
  strokeWeight(outlineWeight);
  textFont(createFont("Consolas", 11));

  // Initialize variables
  cellWidth = (width - 2 * padding) / numCols;
  cellHeight = (height - 2 * padding - bottomPadding) / numRows;
  dummyCell = new DummyCell(); // Initialize singleton DummyCell
  iterationRow = 1;

  initializeCells();

}

void draw() {
  background(0);

  print(iterationRow);

  updateCells();
  drawCells();

  iterationRow += 1;
  if (iterationRow == numRows) {
    println();
    backpropagate();
    println();

    iterationRow = 1;
    dataItem += 1;
  }
}

void updateCells() {
  for (int col = 0; col < numCols; col++) {
    Cell[] parents = getAdjacent(iterationRow - 1, col);
    cells[iterationRow][col].forward(parents);
  }
}

Cell[] getAdjacent(int row, int col) {
  /* Call on (row - 1, col) to get "parents". Call on (row+1, col) to get "children". */
  Cell[] adjacent = new Cell[3];

  try {
    adjacent[0] = cells[row][col-1];
  }
  catch (ArrayIndexOutOfBoundsException e) {
    adjacent[0] = dummyCell;
  }

  adjacent[1] = cells[row][col];

  try {
    adjacent[2] = cells[row][col+1];
  }
  catch (ArrayIndexOutOfBoundsException e) {
    adjacent[2] = dummyCell;
  }

  return adjacent;
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

float sigmoidPrime(float x) {
  // According to https://en.wikipedia.org/wiki/Logistic_function#Derivative
  return x * (1 - x);
}

void backpropagate() {
  float totalCost = 0;
  // float[] errors = new float[numCols];
  Cell cell;
  float target, out, error, nodeDelta, dEdW, prevOut;
  Cell[] parents, children;

  for (int row = numRows - 1; row > 1; row--) {
    for (int col = 0; col < numCols; col++) {
      cell = cells[row][col];
      out = cell.getActivation();

      if (row == numRows - 1) {
        // Special case for the bottom row
        target = cells[0][col].getActivation(); // Temporarily using input as target output >:)
        error = target - out;
        nodeDelta = -error;
        totalCost += pow(error, 2);
      }
      else {
        nodeDelta = 0;
        children = getAdjacent(row + 1, col);
        for (int i = 0; i < 3; i++) {
          nodeDelta += children[i].nodeDelta * cell.getResponse(i);
        }
      }

      nodeDelta *= sigmoidPrime(out); // Chain on derivative of activation function (sigmoid).
      cell.nodeDelta = nodeDelta;

      parents = getAdjacent(row - 1, col);
      for (int i = 0; i < 3; i++) {
        prevOut = parents[i].getActivation();

        dEdW = nodeDelta * prevOut;

        cell.updateWeight(i, dEdW * trainingRate);
      }
    }
  }

  // Omitting the 1/2 * totalCost;
  print(totalCost);
}