class Cell {
  // Represents a Stimulus cell, and also is the base class for all other kinds of cells.
  float activation;

  float getActivation() {
    return activation;
  }

  void setActivation(float activation) {
    this.activation = activation;
  }

  color getOutlineColor() {
    return color(0.5); // Use gray as the outline color for Stimuli cells.
  }

  color getFillColor() {
    return color(activation);
  }
}


class Neuron extends Cell {
  float activation;
  float[] weights;
  float bias;
  float nodeDelta;

  Neuron(int numWeights) {
    // Initialize the weights array randomly
    float[] weights = new float[numWeights];
    for (int i = 0; i < numWeights; i++) {
      weights[i] = constrain(randomGaussian() * initialStdDev,  -1, 1);
    }
    this.weights = weights;
    activation = 0;
  }

  float getActivation() {
    return activation;
  }

  void setActivation(float activation) {
    this.activation = activation;
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

  void updateActivation(Cell[] parents) {
    // Forward propagation: Set my activation to be the weighted sum of parents' activations, plus a "bias",
    // put through an activation function (we use the logistic function)
    float sum = 0;
    for (int i = 0; i < parents.length; i++) {
      sum += parents[i].getActivation() * weights[i];
    }
    activation = sigmoid(sum + bias);
  }

  void updateWeights(Cell[] parents) {
    // Backpropagation: Update my weights and bias using nodeDelta.
    // Assumes updateNodeDelta has already been called.
    for (int i = 0; i < parents.length; i++) {
      float parentActivation = parents[i].getActivation();
      weights[i] -= nodeDelta * parentActivation * learningRate;
    }

    bias -= nodeDelta * biasLearningRate;
  }

  void updateNodeDelta(Cell[] children) {
    // From https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/,
    // nodeDelta of hidden layer neurons is sum( nodeDeltas of next layer * weights of those connections ) * g'(out),
    // where g' is the derivative of the activation function.
    nodeDelta = 0;
    for (int i = 0; i < children.length; i++) {
      float childNodeDelta = ((Neuron) children[i]).nodeDelta;
      nodeDelta += childNodeDelta * weights[i];
    }

    // Chain on the derivative of the activation function.
    // From https://en.wikipedia.org/wiki/Logistic_function#Derivative, 
    // if g is the logistic function, g'(x) = g(x) * g(1 - x)
    // And g(x) is just the activation, so:
    nodeDelta *= activation * (1 - activation);
  }
}


class OutputNeuron extends Neuron {
  float target;

  OutputNeuron(int numWeights) {
    super(numWeights);
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
