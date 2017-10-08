class Cell {
  float activation;

  Cell() { }

  Cell(float activation) {
    this.activation = activation;
  }

  void update() { }

  color getColor() {
    return color(activation);
  }
}

class Neuron extends Cell {
  float activation = 0;
  float[] response;

  // If no response array is provided, initialize it randomly.
  Neuron() {
    float[] response = new float[3];
    for (int i = 0; i < 3; i++) {
      response[i] = constrain(0.5 + 0.1 * randomGaussian(), 0, 1);
    }
    this.response = response;
  }

  Neuron(float[] response) {
    this.response = response;
  }

  void update() {

  }

  color getColor() {
    return color(response[0], response[1], response[2]);
  }
}