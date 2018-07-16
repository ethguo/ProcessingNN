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

NeuralNetwork model;
int iterationLayer = 0;
int phase = 1;
boolean paused = false;
int speed = 0;
int imageTotalHeight = imageHeight * imagePixelHeight;

void settings() {
  // Set window size based on numCols, numLayers.
  int windowWidth = max(shape[1]*cellWidth, imageWidth*imagePixelWidth);
  int windowHeight = imageTotalHeight + shape.length*cellHeight + cellHeight/2;
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

  // Set up the model
  model = new NeuralNetwork(shape, learningRate, biasLearningRate);
  model.setRandomWeights(initialStdDev);
  model.updateStimuli();
}


void draw() {
  model.updateNextRow();
  drawModel();
}


void drawModel() {
  background(0);

  // Draw input image
  Layer layer = model.layers[0];
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
  for (int row = 1; row < shape.length; row++) {
    layer = model.layers[row];
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
    int y = shape.length * cellHeight + imageTotalHeight;
    
    for (int col = 0; col < shape[shape.length-1]; col++) {
      int x = col * cellWidth;
      
      OutputNeuron outputNeuron = (OutputNeuron) model.layers[shape.length-1].cells[col];
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
    model.updateAll();
  }
}
