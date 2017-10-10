class Cell {
  /* Represents a Stimulus cell, and also is the base class for all other kinds of cells. */
  float activation;
  float nodeDelta;

  float getActivation() {
    return activation;
  }

  void setActivation(float activation) {
    this.activation = activation;
  }

  color getStrokeColor() {
    return color(0.5);
  }

  color getFillColor() {
    return color(activation);
  }
}


class Neuron extends Cell {
  float activation;
  float[] weights;
  float bias;

  Neuron(int numWeights) {
    // Initialize the weights array randomly
    float[] weights = new float[numWeights];
    for (int i = 0; i < numWeights; i++) {
      weights[i] = constrain(randomGaussian() * initialStdDev, -1, 1);
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

  float getWeights(int i) {
    return weights[i];
  }

  float getBias() {
    return bias;
  }

  color getStrokeColor() {
    float r = (weights[0] + 1) / 2;
    float g = (weights[1] + 1) / 2;
    float b = (weights[2] + 1) / 2;
    return color(r, g, b);
  }

  color getFillColor() {
    float r = (weights[0] + 1) / 2 * activation;
    float g = (weights[1] + 1) / 2 * activation;
    float b = (weights[2] + 1) / 2 * activation;
    return color(r, g, b);
  }

  void forward(Cell[] parents) {
    float sum = 0;
    for (int i = 0; i < parents.length; i++) {
      sum += parents[i].getActivation() * weights[i];
    }
    activation = sigmoid(sum + bias);
  }

  void backpropagate(Cell[] parents) {
    for (int i = 0; i < parents.length; i++) {
      float prevOut = parents[i].getActivation();
      weights[i] -= nodeDelta * prevOut * learningRate;
    }
    bias -= nodeDelta * biasLearningRate;
  }

  void updateNodeDelta(Cell[] children) {
    nodeDelta = 0;
    for (int i = 0; i < children.length; i++) {
      nodeDelta += children[i].nodeDelta * weights[i];
    }

    nodeDelta *= activation * (1 - activation); // Chain on derivative of activation function (sigmoid).
    // Derivative: https://en.wikipedia.org/wiki/Logistic_function#Derivative
  }
}


class OutputNeuron extends Neuron {
  float target;

  OutputNeuron(int numWeights) {
    super(numWeights);
  }

  float getTarget() {
    return target;
  }

  void setTarget(float target) {
    this.target = target;
  }

  void updateNodeDelta() {
    float error = target - activation;

    nodeDelta = -error * activation * (1 - activation); // Chain on derivative of activation function (sigmoid).
  }
}


float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}
