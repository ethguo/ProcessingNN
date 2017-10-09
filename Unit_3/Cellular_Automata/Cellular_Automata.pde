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
int iterationRow, phase;
DummyCell dummyCell;

void setup() {
  size(1200, 600);
  frameRate(framerate);

  // Drawing settings
  colorMode(RGB, 1.0, 1.0, 1.0);
  strokeWeight(outlineWeight);
  textFont(createFont("Consolas", 11));

  // Initialize variables
  cells = new Cell[numRows][numCols];
  cellWidth = (width - 2 * padding) / numCols;
  cellHeight = (height - 2 * padding - bottomPadding) / numRows;
  dummyCell = new DummyCell(); // Initialize singleton DummyCell
  iterationRow = 0;
  phase = 1;

  initializeNeurons();
  updateStimuli();
}

void draw() {
  updateCells();
  drawCells();
}

void updateCells() {
  print(iterationRow);
  print(" " + phase);

  if (iterationRow == 0)
    updateStimuli();
  else if (iterationRow < numRows)
    updateNeurons(iterationRow);
  else // iterationRow == numRow
    updateNodeDeltas();

  if (phase == 1) {
    iterationRow++;
    if (iterationRow == numRows) {
      phase = 2;
    }
  }
  else { // phase == 2
    iterationRow--;
    if (iterationRow == 0) {
      phase = 1;
    }
  }

  println();
}

void initializeNeurons() {
  // Initialize neurons
  int row;
  for (row = 1; row < numRows-1; row++) {
    for (int col = 0; col < numCols; col++) {
      cells[row][col] = new Neuron();
    }
  }

  for (int col = 0; col < numCols; col++) {
    cells[row][col] = new OutputNeuron();
  }
}

void updateStimuli() {
  // Initialize stimuli (in row 0)
  for (int col = 0; col < numCols; col++) {
    float x = round(random(0, 1));
    cells[0][col] = new Cell(x);

    ((OutputNeuron) cells[numRows-1][col]).setTarget(1 - x); // Temporarily using input as target output >:)
  }
}

void updateNeurons(int row) {
  for (int col = 0; col < numCols; col++) {
    Neuron cell = (Neuron) cells[row][col];
    Cell[] parents = getAdjacent(row - 1, col);
    if (phase == 1) // Phase 1: Forward propagation
      cell.forward(parents);
    else // Phase 2: Backpropagation
      cell.backpropagate(parents);
  }
}

void updateNodeDeltas() {
  print("updateNodeDeltas");
  int row = numRows - 1;
  for (int col = 0; col < numCols; col++) {
    OutputNeuron cell = (OutputNeuron) cells[row][col];
    cell.updateNodeDelta();
  }
  for (row = numRows-2; row > 1; row--) {
    for (int col = 0; col < numCols; col++) {
      Cell[] children = getAdjacent(row + 1, col);
      Neuron cell = (Neuron) cells[row][col];
      cell.updateNodeDelta(children);
    }
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
  background(0);
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      Cell cell = cells[row][col];

      float x = padding + col * cellWidth;
      float y = padding + row * cellHeight;

      color strokeColor = cell.getStrokeColor();
      color fillColor;
      if (coloredFill)
        fillColor = cell.getFillColor();
      else
        fillColor = color(cell.getActivation());
      stroke(strokeColor);
      fill(fillColor);

      rect(x, y, cellWidth - outlineWeight, cellHeight - outlineWeight);

      if (showText) {
        fill(round(1 - brightness(fillColor))); // Pick either black or white, for maximum contrast

        String a  = " A:" + nfs(cell.getActivation(), 1, 2);
        text(a,  x + outlineWeight, y + 10 + outlineWeight);
        if (row > 0) {
          String r0 = "R0:" + nfs(cell.getResponse(0), 1, 2);
          String r1 = "R1:" + nfs(cell.getResponse(1), 1, 2);
          String r2 = "R2:" + nfs(cell.getResponse(2), 1, 2);
          text(r0, x + outlineWeight, y + 20 + outlineWeight);
          text(r1, x + outlineWeight, y + 30 + outlineWeight);
          text(r2, x + outlineWeight, y + 40 + outlineWeight);
        }
      }
    }
  }
}
