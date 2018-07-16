class NeuralNetwork {
  int[] shape;
  float learningRate;
  float biasLearningRate;

  Layer[] layers;

  private int numLayers;


  NeuralNetwork(int[] shape, float learningRate, float biasLearningRate) {
    this.shape = shape;
    this.learningRate = learningRate;
    this.biasLearningRate = biasLearningRate;

    numLayers = shape.length;

    layers = new Layer[numLayers];
    int i = 0;

    // Initialize Input Layer
    layers[i] = new InputLayer(shape[i]);

    // Initialize Hidden Layers
    for (i = 1; i < numLayers-1; i++) {
      layers[i] = new HiddenLayer(shape[i], layers[i-1]);
    }

    // Initialize Output Layer
    layers[i] = new OutputLayer(shape[i], layers[i-1]);

    // Set nextLayers
    for (i = 1; i < numLayers-1; i++) {
      HiddenLayer hiddenLayer = (HiddenLayer) layers[i];
      hiddenLayer.setNextLayer(layers[i+1]);
    }
  }


  void setRandomWeights(float stdDev) {
    for (int i = 1; i < numLayers; i++) {
      HiddenLayer hiddenLayer = (HiddenLayer) layers[i];
      hiddenLayer.setRandomWeights(stdDev);
    }
  }

  void updateAll() {
    updateAll();
  }


  void updateNextRow() {
    // We update one row of cells at a time.
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

    layers[0].setActivations(inputs);

    OutputLayer outputLayer = (OutputLayer) layers[numLayers-1];
    outputLayer.setTargets(outputs);

    if (speeds[speed] < 10) { // Only do this on low framerates, to prevent flickering at higher speeds.
      // Set all activations (other than the stimuli) back to zero.
      for (int row = 1; row < numLayers; row++) {
        layers[row].setActivations(0);
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
}