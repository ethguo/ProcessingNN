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

  color getStrokeColor() {
    return color(0);
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
      response[i] = constrain(0.5 + 0.1 * randomGaussian(), 0, 1);
    }
    this.response = response;
    activation = 0;
  }

  Neuron(float[] response) {
    this.response = response;
    activation = 0;
  }

  void forward(Cell[] neighbours) {
    float sum = 0;
    for (int i = 0; i < 3; i++) {
      sum += neighbours[i].getActivation() * response[i];
    }
    activation = sum / 3;
    activation = 1;
    print(activation);
    print(" ");
  }

  color getStrokeColor() {
    return color(response[0], response[1], response[2]);
  }

  color getFillColor() {
    return color(response[0] * activation, response[1] * activation, response[2] * activation);
  }
}
