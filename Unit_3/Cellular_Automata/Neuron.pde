class Cell {
  /**
   * Represents a Stimulus cell, and also is the base class for all other kinds of cells.
   */
  float activation;
  float nodeDelta;

  Cell() { }

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

  Neuron() {
    // Initialize the weights array randomly
    float[] weights = new float[3];
    for (int i = 0; i < 3; i++) {
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
    for (int i = 0; i < 3; i++) {
      sum += parents[i].getActivation() * weights[i];
    }
    activation = sigmoid(sum + bias);
  }

  void backpropagate(Cell[] parents) {
    for (int i = 0; i < 3; i++) {
      float prevOut = parents[i].getActivation();
      weights[i] -= nodeDelta * prevOut * learningRate;
    }
    bias -= nodeDelta * biasLearningRate;
  }

  void updateNodeDelta(Cell[] children) {
    nodeDelta = 0;
    for (int i = 0; i < 3; i++) {
      nodeDelta += children[i].nodeDelta * weights[i];
    }
    // Negative?
    nodeDelta *= sigmoidPrime(activation); // Chain on derivative of activation function (sigmoid).
  }
}


class OutputNeuron extends Neuron {
  float target;

  void setTarget(float target) {
    this.target = target;
  }

  void updateNodeDelta() {
    // Special case for the bottom row
    float error = target - activation;
    // totalCost += pow(error, 2);

    nodeDelta = -error * sigmoidPrime(activation); // Chain on derivative of activation function (sigmoid).
  }
}


float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}

float sigmoidPrime(float x) {
  // According to https://en.wikipedia.org/wiki/Logistic_function#Derivative
  return x * (1 - x);
}
