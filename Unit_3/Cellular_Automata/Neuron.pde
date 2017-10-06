class Cell {
  float activation;

  Cell(float activation) {
    this.activation = activation;
  }
}

class Neuron extends Cell {
  float activation = 0;
  float[] response;

  // If no response array is provided, initialize it randomly.
  Neuron() {
    float[] response = new float[3];
    for (int i; i < 3; i++) {
      response[i] = constrain(randomGaussian() * 0.1);
    }
    this.response = response;
  }

  Neuron(float[] response) {
    this.response = response;
  }
}