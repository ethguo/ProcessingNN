/* PARAMETERS */
int numCols = 20;
int numRows = 20;
float padding = 20;
float framerate = 0.5;
/* END OF PARAMETERS */

Cell[][] cells;
float cellWidth, cellHeight;
int iterationRow = 0;

void setup(){
  size(800, 800);
  frameRate(framerate);

  // colorMode(HSB, 2*PI, 1.0, 1.0);

  colorMode(RGB, 1.0, 1.0, 1.0);

  cellWidth = (width-2*padding)/numCols;
  cellHeight = (height-2*padding)/numRows;

  background(0);
}

void draw() {
  if (iterationRow == 0)
    initializeCells();
  else if (iterationRow < numRows - 1)
    updateCells();
  else
    println("End of iterations");

  drawCells();

  iterationRow += 1;
}


void updateCells() {
  // Can probably simplify this because we're processing row at a time
  Cell[][] nextCells = new Cell[numRows][numCols];

  for (int col = 0; col < numCols; col++) {
    cells[iterationRow][col].update();
  }

  // for (int col = 0; col < numCols; col++) {
  //   nextCells[iterationRow][col] = updateNeuron(col);
  // }

  // for (int col = 0; col < numCols; col++) {
  //   cells[iterationRow][col] = nextCells[iterationRow][col];
  // }
}

void drawCells() {
  float y = padding;
  
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      float x = padding + col*cellWidth;

      fill(cells[row][col].getColor());
      
      rect(x, y, cellWidth, cellHeight);
    }
    y += cellHeight;
  }
}

void initializeCells() {
  cells = new Cell[numRows][numCols];

  // Initialize stimuli
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
