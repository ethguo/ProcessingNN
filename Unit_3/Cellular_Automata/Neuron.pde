class Cell {
  // Represents a Stimulus cell, and also is the base class for all other kinds of cells.
  float activation;

  color getOutlineColor() {
    return color(0.5); // Use gray as the outline color for Stimuli cells.
  }

  color getFillColor() {
    return color(activation);
  }
}


class Neuron extends Cell {
  Layer prevLayer;
  Layer nextLayer;
  float[] weights;
  float bias;
  float nodeDelta;
  float learningRate;
  float biasLearningRate;

  Neuron(Layer prevLayer, float learningRate, float biasLearningRate) {
    this.prevLayer = prevLayer;
    this.learningRate = learningRate;
    this.biasLearningRate = biasLearningRate;
    this.weights = new float[prevLayer.length];
    activation = 0;
  }

  void setRandomWeights(float stdDev) {
    // Initialize the weights array randomly
    for (int i = 0; i < weights.length; i++) {
      weights[i] = constrain(randomGaussian() * stdDev,  -1, 1);
    }
  }

  void setNextLayer(Layer nextLayer) {
    this.nextLayer = nextLayer;
  }

  color getOutlineColor() {
    // Scale weights from -1..1 to 0..1 for RGB.
    float r = constrain((weights[0] + 1) / 2,  0, 1);
    float g = constrain((weights[1] + 1) / 2,  0, 1);
    float b = constrain((weights[2] + 1) / 2,  0, 1);
    return color(r, g, b);
  }

  color getFillColor() {
    // Scale weights from -1..1 to 0..1, scaled by the activation.
    float r = constrain((weights[0] + 1) / 2 * activation,  0, 1);
    float g = constrain((weights[1] + 1) / 2 * activation,  0, 1);
    float b = constrain((weights[2] + 1) / 2 * activation,  0, 1);
    return color(r, g, b);
  }

  void updateActivation() {
    // Forward propagation: Set my activation to be the weighted sum of parents' activations, plus a "bias",
    // put through an activation function (we use the logistic function).
    float sum = 0;
    for (int i = 0; i < prevLayer.length; i++) {
      sum += prevLayer.cells[i].activation * weights[i];
    }
    activation = sigmoid(sum + bias);
  }

  void updateWeights() {
    // Backpropagation: Update my weights and bias using nodeDelta.
    // Assumes updateNodeDelta has already been called.
    for (int i = 0; i < prevLayer.length; i++) {
      float parentActivation = prevLayer.cells[i].activation;
      weights[i] -= nodeDelta * parentActivation * learningRate;
    }

    bias -= nodeDelta * biasLearningRate;
  }

  void updateNodeDelta() {
    // From https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/,
    // nodeDelta is essentially the partial derivative of the total error with respect to the input to this neuron.
    // Then, the partial derivative of the total error with respect to each weight is just
    // nodeDelta times the activation of the input neuron associated with that weight.
    // Similarily, the calculation for the nodeDelta of neurons in the next layer up also requires this.
    // So, storing nodeDelta saves us from having recalcuate this derivative every time we need it (for both
    // updating this neuron's weights, and for updating the next layer's nodeDeltas).
    
    // nodeDelta of hidden layer neurons is sum( nodeDeltas of next layer * weights of those connections ) * g'(out),
    // where g' is the derivative of the activation function.
    nodeDelta = 0;
    for (int i = 0; i < nextLayer.length; i++) {
      float childNodeDelta = ((Neuron) nextLayer.cells[i]).nodeDelta;
      nodeDelta += childNodeDelta * weights[i];
    }

    // Chain on the derivative of the activation function.
    // From https://en.wikipedia.org/wiki/Logistic_function#Derivative, 
    // if g is the logistic function, then g'(x) = g(x)*(1 - g(x))
    // And g(x) is just this neuron's activation, so:
    nodeDelta *= activation * (1 - activation);
  }
}


class OutputNeuron extends Neuron {
  float target;

  OutputNeuron(Layer prevLayer, float learningRate, float biasLearningRate) {
    super(prevLayer, learningRate, biasLearningRate);
  }

  void updateNodeDelta() {
    // nodeDelta of output layer neurons is -(target - out) * g'(out)
    // (This is the Delta Rule: https://en.wikipedia.org/wiki/Delta_rule)
    float error = target - activation;
    nodeDelta = -error * activation * (1 - activation);
  }
}


// Logistic function (sigmoid curve)
// Widely used as an activation function for neural networks because it has a nice derivative -- see above.
float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}
