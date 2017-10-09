class Cell {
  float activation;
  float nodeDelta;

  Cell() { }

  Cell(float activation) {
    this.activation = activation;
  }

  float getActivation() {
    return activation;
  }

  float getResponse(int i) {
    return 0;
  }

  color getStrokeColor() {
    return color(0.5);
  }

  color getFillColor() {
    return color(activation);
  }

  void updateWeight(int i, float delta) { }
}

class DummyCell extends Cell {
  /**
   * Dummy cell (singleton), returned when trying to access a cell that is out of bounds.
   */
  float activation = 0;
}

class Neuron extends Cell {
  float activation;
  float[] response;

  // If no response array is provided, initialize it randomly.
  Neuron() {
    float[] response = new float[3];
    for (int i = 0; i < 3; i++) {
      response[i] = constrain(randomGaussian(), -1, 1);
    }
    this.response = response;
    activation = 0;
  }

  Neuron(float[] response) {
    this.response = response;
    activation = 0;
  }

  float getActivation() {
    return activation;
  }

  float getResponse(int i) {
    return response[i];
  }

  void forward(Cell[] parents) {
    float sum = 0;
    for (int i = 0; i < 3; i++) {
      sum += parents[i].getActivation() * response[i];
    }
    activation = sigmoid(sum);
  }

  void backpropagate(Cell[] parents) {
    for (int i = 0; i < 3; i++) {
      float prevOut = parents[i].getActivation();
      response[i] -= nodeDelta * prevOut * trainingRate;
    }
  }

  void updateNodeDelta(Cell[] children) {
    nodeDelta = 0;
    for (int i = 0; i < 3; i++) {
      nodeDelta += children[i].nodeDelta * response[i];
    }
    nodeDelta *= sigmoidPrime(activation); // Chain on derivative of activation function (sigmoid).
  }

  color getStrokeColor() {
    float r = (response[0] + 1) / 2;
    float g = (response[1] + 1) / 2;
    float b = (response[2] + 1) / 2;
    return color(r, g, b);
  }

  color getFillColor() {
    float r = (response[0] + 1) / 2 * activation;
    float g = (response[1] + 1) / 2 * activation;
    float b = (response[2] + 1) / 2 * activation;
    return color(r, g, b);
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
