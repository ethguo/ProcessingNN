/* NOTES
 * 
 * If using numRows = 3, it'll usually take at least a minute running the simulation at maximum speed before you start seeing decent predictions.
 * If using even more numRows, it'll take even longer. Using numRows = 4 with the Iris dataset, it took about 10 minutes (running at maximum speed).
 * The longer you train however, the better the results. Try leaving one or two windows open when you're taking a break etc.
 * 
 * Keyboard controls:
 *   Pressing 'p' will pause/unpause the simulation.
 *   Pressing '+' will increase the speed of the simulation (within a list of preset speeds).
 *   Pressing '-' will decrease the speed of the simulation (within a list of preset speeds).
 *   Other keyboard controls are documented next to their relevant parameters below ('t', 'f', and 'o').
 * 
 * Interesting demos:
 *  - Try each of the "toy" datasets (dataset1.json, dataset2.json, dataset3.json) with numRows = 2. Remember to change numCols!
 *  - Try toy dataset 1 or 2 with numRows = 3. This will take longer to train, so let it run for a few minutes at maximum speed.
 *  - To use the famous Iris Dataset, for best results, set these parameters:
 *       dataFile = "iris.json"
 *       numCols = 4
 *       numRows = 3 or 4 (4 takes much longer to train)
 *       fullConnections = true
 *       learningRate = 3 (lower might give better results in the long term, but takes longer to train)
 *       biasLearningRate = 0.1
 *       initialStdDev = 0.1
 */

/* PARAMETERS */
/* Data */ 
String dataFile = "mnist.json"; // Loads this json file, containing a set of inputs and expected outputs. Remember to change numCols whenever you change this.
int numCols = 784; // Please manually set to match the "columns" property in the data file. Cannot be set automatically due to the limits of Processing.

/* Neural Network Tuning */
int numRows = 3; // How many layers? (Counting stimuli layer and output layer; minimum 2)
boolean fullConnections = true; // false: A cell's connections are the three adjacent cells above/below it.
                                // true:  A cell is connected to every cell in the layer above/below it (More like a real neural network).
float learningRate = 0.005; // How much the neural network updates the weights each time. Setting this too high can make it unstable.
                            // Setting this lower can give better results, but will take longer to train.
float biasLearningRate = 0.0005; // How much the neural network updates the biases each time
float initialStdDev = 0.01; // How strong the initial weights are.

/* Graphics */
int outlineWeight = 4; // The thickness of the outline.
int cellWidth = 64;
int cellHeight = 64;
boolean showText = false; // If true, displays text on each cell displaying the exact numeric values of each cell's activation, weights and bias.
                          // Pressing 't' will toggle this while running.
boolean coloredFill = false; // If true, uses the color of the outline to tint the fill color of the cell (purely for aesthetics).
                             // Pressing 'f' will toggle this while running.
boolean showExpectedOutput = true; // If true, indicates the expected output(s) as a small bar under the bottom row of cells.
                                   // Pressing 'o' will toggle this while running.
boolean noDraw = false;
float[] speeds = {2, 10, 60, 10000}; // The set of speeds that can be cycled through (in frames per second).
                                 // Pressing '-' and '+' will cycle through these speeds while running.

/* END OF PARAMETERS */

// Globals
JSONObject dataObject;
JSONArray data;
int dataSize;

Cell[][] cells;
int iterationRow = 0;
int phase = 1;
boolean paused = false;
int speed = 0;
int i = 0;
int t0 = 0;

void settings() {
  // Set window size based on numCols, numRows.
  int windowWidth = min(numCols * cellWidth, 1920);
  int windowHeight = numRows * cellHeight + cellHeight / 2;
  size(windowWidth, windowHeight);

  noSmooth(); // Turn off antialiasing, to make borders look nicer (because everything is horizontal/vertical anyways).
}


void setup() {
  // Drawing settings
  frameRate(speeds[0]);
  colorMode(RGB, 1.0, 1.0, 1.0);
  strokeWeight(outlineWeight);
  textFont(createFont("Consolas", 11));

  // Load data file
  dataObject = loadJSONObject(dataFile);
  data = dataObject.getJSONArray("data");
  dataSize = data.size();

  // Set up the simulation
  initializeCells();
  updateStimuli();
}


void draw() {
  updateCells();
  drawCells();
}


void initializeCells() {
  cells = new Cell[numRows][numCols];
  int row = 0;

  // Initialize top row of stimuli Cells
  for (int col = 0; col < numCols; col++) {
    cells[row][col] = new Cell();
  }

  // Determine the numWeights (used to initialize the Neurons)
  int numWeights;
  if (fullConnections)
    numWeights = numCols;
  else
    numWeights = 3;

  // Initialize Neurons
  for (row = 1; row < numRows-1; row++) {
    for (int col = 0; col < numCols; col++) {
      cells[row][col] = new Neuron(numWeights);
    }
  }

  // Initialize bottom row of OutputNeurons
  for (int col = 0; col < numCols; col++) {
    cells[row][col] = new OutputNeuron(numWeights);
  }
}


void updateCells() {
  // We always update one row of cells at a time.
  if (iterationRow == 0)
    updateStimuli();
  else if (iterationRow < numRows)
    updateNeurons(iterationRow);
  else // iterationRow == numRows
    updateNodeDeltas(); // At iterationRow = numRows, we don't update any actual cells, but instead we calculate all the nodeDeltas.

  if (phase == 1) {
    // In phase 1, we count up from iterationRow=0 to iterationRow=numRows.
    iterationRow++; 
    if (iterationRow == numRows) {
      phase = 2;
    }
  }
  else { // phase == 2
    // In phase 2, we count down from iterationRow=numRows to iterationRow=0.
    iterationRow--;
    if (iterationRow == 0) {
      phase = 1;
    }
  }

  i++;
  if (i == 100) {
    int t1 = millis();
    println(t1 - t0);
    t0 = t1;
    i = 0;
  }
}


void updateStimuli() {
  // Updating the stimuli means getting a new data item.

  int i = int(random(dataSize)); // Randomly select one of the data items.
  JSONObject dataItem = data.getJSONObject(i);
  JSONArray inputs = dataItem.getJSONArray("input");
  JSONArray outputs = dataItem.getJSONArray("output");

  for (int col = 0; col < numCols; col++) {
    float input = inputs.getFloat(col);
    float output = outputs.getFloat(col);

    // Set the activation of the corresponding stimuli (in row 0).
    cells[0][col].activation = input;

    // Set the target value of the corresponding OutputNeuron.
    OutputNeuron outputNeuron = (OutputNeuron) cells[numRows-1][col];
    outputNeuron.target = output;
  }

  if (speeds[speed] < 10) { // Only do this on low framerates, to prevent flickering at higher speeds.
    // Set all activations (other than the stimuli) back to zero.
    for (int row = 1; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        cells[row][col].activation = 0;
      }
    }
  }
}


void updateNeurons(int row) {
  // Updating neurons in phase 1 and phase 2 is almost exactly the same,
  // the only difference is which method gets called (cell.updateActivation vs. cell.updateWeights).
  for (int col = 0; col < numCols; col++) {
    Neuron cell = (Neuron) cells[row][col];

    // Either way, it needs a list of references to the connected cells in the layer before it.
    Cell[] parents = getConnections(row - 1, col);
    
    if (phase == 1) // Phase 1: Forward propagation
      cell.updateActivation(parents);
    else // Phase 2: Backpropagation
      cell.updateWeights(parents);
  }
}


void updateNodeDeltas() {
  // Calculate all nodeDeltas. This is the number that makes backpropagation work.
  int row = numRows - 1;
  for (int col = 0; col < numCols; col++) {
    OutputNeuron cell = (OutputNeuron) cells[row][col];
    cell.updateNodeDelta();
  }
  for (row = numRows-2; row > 1; row--) {
    for (int col = 0; col < numCols; col++) {
      Cell[] children = getConnections(row + 1, col);
      Neuron cell = (Neuron) cells[row][col];
      cell.updateNodeDelta(children);
    }
  }
}


Cell[] getConnections(int row, int col) {
  // Call on (row - 1, col) to get "parents". Call on (row + 1, col) to get "children".
  Cell[] connections;
  if (fullConnections) {
    // If fullConnections mode is on, the list of connected cells is just the entire row.
    connections = cells[row];
  }
  else {
    // Otherwise, the connections is a list of 3 cells:
    // diagonally left, directly above (or below, in the case of "children"), and diagonally right.
    connections = new Cell[3];

    try {
      connections[0] = cells[row][col-1];
    }
    catch (ArrayIndexOutOfBoundsException e) {
      // If out of bounds, "wrap around" and return the cell at the end of the row.
      connections[0] = cells[row][numCols-1];
    }

    // The middle one can't be out of bounds.
    connections[1] = cells[row][col];

    try {
      connections[2] = cells[row][col+1];
    }
    catch (ArrayIndexOutOfBoundsException e) {
      // If out of bounds, "wrap around" and return the cell at the beginning of the row.
      connections[2] = cells[row][0];
    }
  }
  return connections;
}


void drawCells() {
  background(0);
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      Cell cell = cells[row][col];

      int x = col * cellWidth + outlineWeight / 2;
      int y = row * cellHeight + outlineWeight / 2;

      // Get the outline and fill color for this cell.
      color outlineColor = cell.getOutlineColor();
      color fillColor;
      if (coloredFill)
        fillColor = cell.getFillColor();
      else // If coloredFill is off, used cell's activation value as grayscale value.
        fillColor = color(cell.activation);

      stroke(outlineColor);
      fill(fillColor);

      rect(x, y, cellWidth - outlineWeight, cellHeight - outlineWeight);

      if (showText) {
        fill(round(1 - brightness(fillColor))); // Pick either black or white text, for maximum contrast.

        int xText = x + outlineWeight;
        int yText = y + outlineWeight + 10;

        // For all cells (Stimuli or Neuron), numerically display the activation value.
        String textA = " A:" + nfs(cell.activation, 1, 2);
        text(textA, xText, yText);

        if (row > 0) {
          // If the cell is a Neuron, also display the weights and bias values.
          Neuron neuron = (Neuron) cell;

          String textW0 = "W0:" + nfs(neuron.weights[0], 1, 2);
          String textW1 = "W1:" + nfs(neuron.weights[1], 1, 2);
          String textW2 = "W2:" + nfs(neuron.weights[2], 1, 2);
          String textB  = " B:" + nfs(neuron.bias,     1, 2);

          text(textW0, xText, yText + 10);
          text(textW1, xText, yText + 20);
          text(textW2, xText, yText + 30);
          text(textB,  xText, yText + 40);
        }
      }
    }
  }

  if (showExpectedOutput) {
    noStroke();
    int y = numRows * cellHeight;
    
    for (int col = 0; col < numCols; col++) {
      int x = col * cellWidth;
      
      OutputNeuron outputNeuron = (OutputNeuron) cells[numRows-1][col];
      fill(color(outputNeuron.target)); // Use the target value as grayscale value.

      rect(x, y, cellWidth, cellHeight / 2);
    }
  }
}


void keyPressed() {
  if (key == '=' || key == '+') {
    if (speed < speeds.length - 1) { // If we're already at the highest speed, do nothing.
      speed++;
      frameRate(speeds[speed]);
    }
  }
  if (key == '-' || key == '_') {
    if (speed > 0) { // If we're already at the lowest speed, do nothing.
      speed--;
      frameRate(speeds[speed]);
    }
  }
  else if (key == 'p' || key == 'P') {
    paused = !paused; // Toggle paused
    if (paused)
      noLoop();
    else
      loop();
  }
  else if (key == 't' || key == 'T') {
    showText = !showText; // Toggle showText
  }
  else if (key == 'f' || key == 'F') {
    coloredFill = !coloredFill; // Toggle coloredFill
  }
  else if (key == 'o' || key == 'O') {
    showExpectedOutput = !showExpectedOutput; // Toggle showExpectedOutput
  }
  else if (key == 'n' || key == 'N') {
    println("key n");
    noDraw = !noDraw; // Toggle noDraw
    if (noDraw)
      noDrawMode();
    else
      loop();
  }
}

void noDrawMode() {
  noLoop();

  background(0);
  fill(1);
  text("Training...", 20, 20);
  redraw();

  thread("noDrawModeLoop");
}

void noDrawModeLoop() {
  while (noDraw) {
    updateCells();
  }
}
