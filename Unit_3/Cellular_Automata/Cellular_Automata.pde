/* NOTES
 * Keyboard controls:
 *   Pressing 'p' will pause/unpause the simulation.
 *   Pressing '+' will increase the speed of the simulation (within a list of preset speeds).
 *   Pressing '-' will decrease the speed of the simulation (within a list of preset speeds).
 *   Other keyboard controls are documented next to their relevant parameters below ('t', 'f', and 'o').
 */

/* PARAMETERS */
/* Data */ 
String dataFile = "mnist-full.json"; // Loads this json file, containing a set of inputs and expected outputs. Remember to change numCols whenever you change this.
// int numCols = 784; // Please manually set to match the "columns" property in the data file. Cannot be set automatically due to the limits of Processing.
int imageWidth = 28;
int imageHeight = 28;

/* Neural Network Tuning */
int[] shape = {784, 16, 16, 10}; // Please set the first item to match the "columns" property in the data file. Cannot be set automatically due to the limits of Processing.
float learningRate = 0.005; // How much the neural network updates the weights each time. Setting this too high can make it unstable.
                            // Setting this lower can give better results, but will take longer to train.
float biasLearningRate = 0.0005; // How much the neural network updates the biases each time
float initialStdDev = 0.01; // How strong the initial weights are.

/* Graphics */
int cellWidth = 64;
int cellHeight = 64;
int imagePixelWidth = 10;
int imagePixelHeight = 10;
int cellMargin = 2; // The thickness of the outline.
int imagePixelMargin = 0;
boolean showText = false; // If true, displays text on each cell displaying the exact numeric values of each cell's activation, weights and bias.
                          // Pressing 't' will toggle this while running.
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

Layer[] layers;
int numLayers = shape.length;
int iterationLayer = 0;
int phase = 1;
boolean paused = false;
int speed = 0;
int imageTotalHeight = imageHeight * imagePixelHeight;

void settings() {
  // Set window size based on numCols, numLayers.
  int windowWidth = max(shape[1]*cellWidth, imageWidth*imagePixelWidth);
  int windowHeight = imageTotalHeight + numLayers*cellHeight + cellHeight/2;
  windowWidth = min(windowWidth, 1920);
  windowHeight = min(windowHeight, 1080);
  size(windowWidth, windowHeight);

  noSmooth(); // Turn off antialiasing, to make borders look nicer (because everything is horizontal/vertical anyways).
}


void setup() {
  // Drawing settings
  frameRate(speeds[0]);
  colorMode(RGB, 1.0, 1.0, 1.0);
  noStroke();
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
  layers = new Layer[numLayers];
  int row = 0;

  // Initialize Input Layer
  layers[row] = new InputLayer(shape[row]);

  // Initialize Hidden Layers
  for (row = 1; row < numLayers-1; row++) {
    layers[row] = new HiddenLayer(shape[row], layers[row-1]);
  }

  // Initialize Output Layer
  layers[row] = new OutputLayer(shape[row], layers[row-1]);

  // Set nextLayers
  for (row = 1; row < numLayers-1; row++) {
    HiddenLayer hiddenLayer = (HiddenLayer) layers[row];
    hiddenLayer.setNextLayer(layers[row+1]);
  }
}


void updateCells() {
  // We always update one row of cells at a time.
  if (iterationLayer == 0)
    updateStimuli();
  else if (iterationLayer < numLayers)
    updateNeurons(iterationLayer);
  else // iterationLayer == numLayers
    updateNodeDeltas(); // At iterationLayer = numLayers, we don't update any actual cells, but instead we calculate all the nodeDeltas.

  if (phase == 1) {
    // In phase 1, we count up from iterationLayer=0 to iterationLayer=numLayers.
    iterationLayer++; 
    if (iterationLayer == numLayers) {
      phase = 2;
    }
  }
  else { // phase == 2
    // In phase 2, we count down from iterationLayer=numLayers to iterationLayer=0.
    iterationLayer--;
    if (iterationLayer == 0) {
      phase = 1;
    }
  }
}


void updateStimuli() {
  // Updating the stimuli means getting a new data item.

  int i = int(random(dataSize)); // Randomly select one of the data items.
  JSONObject dataItem = data.getJSONObject(i);
  JSONArray inputs = dataItem.getJSONArray("input");
  JSONArray outputs = dataItem.getJSONArray("output");

  for (int col = 0; col < shape[0]; col++) {
    float input = inputs.getFloat(col);

    // Set the activation of the corresponding stimuli (in row 0).
    layers[0].setActivation(col, input);
  }

  for (int col = 0; col < shape[numLayers-1]; col++) {
    float output = 0;
    output = outputs.getFloat(col);

    // Set the target value of the corresponding OutputNeuron.
    OutputLayer outputLayer = (OutputLayer) layers[numLayers-1];
    outputLayer.setTarget(col, output);
  }

  if (speeds[speed] < 10) { // Only do this on low framerates, to prevent flickering at higher speeds.
    // Set all activations (other than the stimuli) back to zero.
    for (int row = 1; row < numLayers; row++) {
      for (int col = 0; col < shape[row]; col++) {
        layers[row].setActivation(col, 0);
      }
    }
  }
}


void updateNeurons(int row) {
  // Updating neurons in phase 1 and phase 2 is almost exactly the same,
  // the only difference is which method gets called (cell.updateActivation vs. cell.updateWeights).
  HiddenLayer layer = (HiddenLayer) layers[row];
  if (phase == 1)
    layer.forward();
  else
    layer.backpropagate();
}


void updateNodeDeltas() {
  // Calculate all nodeDeltas. This is the number that makes backpropagation work.
  int row = numLayers - 1;

  OutputLayer outputLayer = (OutputLayer) layers[row];
  outputLayer.updateNodeDeltas();

  for (row = numLayers-2; row > 1; row--) {
    HiddenLayer hiddenLayer = (HiddenLayer) layers[row];
    hiddenLayer.updateNodeDeltas();
  }
}


void drawCells() {
  background(0);

  // Draw input image
  Layer layer = layers[0];
  for (int imageRow = 0; imageRow < imageHeight; imageRow++) {
    for (int imageCol = 0; imageCol < imageWidth; imageCol++) {
      int i = imageRow * imageWidth + imageCol;
      Cell cell = layer.cells[i];

      int x = imageCol * imagePixelWidth + imagePixelMargin / 2;
      int y = imageRow * imagePixelHeight + imagePixelMargin / 2;

      color fillColor = color(cell.activation);
      fill(fillColor);

      rect(x, y, imagePixelWidth - imagePixelMargin, imagePixelHeight - imagePixelMargin);
    }
  }

  // Draw Neuron layers
  for (int row = 1; row < numLayers; row++) {
    layer = layers[row];
    for (int col = 0; col < shape[row]; col++) {
      Cell cell = layer.cells[col];

      int x = col * cellWidth + cellMargin / 2;
      int y = row * cellHeight + cellMargin / 2 + imageTotalHeight;

      // Get the outline and fill color for this cell.
      color fillColor = color(cell.activation);
      fill(fillColor);

      rect(x, y, cellWidth - cellMargin, cellHeight - cellMargin);

      if (showText) {
        fill(round(1 - brightness(fillColor))); // Pick either black or white text, for maximum contrast.

        int xText = x + cellMargin;
        int yText = y + cellMargin + 10;

        // For all cells (Stimuli or Neuron), numerically display the activation value.
        String textA = " A:" + nfs(cell.activation, 1, 2);
        text(textA, xText, yText);

        // if (row > 0) {
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

  if (showExpectedOutput) {
    // noStroke();
    int y = numLayers * cellHeight + imageTotalHeight;
    
    for (int col = 0; col < shape[numLayers-1]; col++) {
      int x = col * cellWidth;
      
      OutputNeuron outputNeuron = (OutputNeuron) layers[numLayers-1].cells[col];
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
  else if (key == 'o' || key == 'O') {
    showExpectedOutput = !showExpectedOutput; // Toggle showExpectedOutput
  }
  else if (key == 'n' || key == 'N') {
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
