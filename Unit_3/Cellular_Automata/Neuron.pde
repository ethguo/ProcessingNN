class Cell {
  float activation;
  Cell[][] cells;

  Cell() { }

  Cell(float activation) {
    this.activation = activation;
  }

  float getActivation() {
    return activation;
  }

  void forward(Cell[] neighbours) { }

  float getResponse(int i) {
    return 0;
  }

  color getStrokeColor() {
    return color(0.5);
  }

  color getFillColor() {
    return color(activation);
  }
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

  void forward(Cell[] neighbours) {
    float sum = 0;
    for (int i = 0; i < 3; i++) {
      sum += neighbours[i].getActivation() * response[i];
    }
    activation = sigmoid(sum);
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
