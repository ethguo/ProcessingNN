class Layer {
  int length;
  Cell[] cells;

  Layer(int length) {
    this.length = length;
    cells = new Cell[length];
  }

  void setActivation(int i, float activation) {
    cells[i].activation = activation;
  }
}


class InputLayer extends Layer {
  InputLayer(int length) {
    super(length);

    for (int i = 0; i < this.length; i++) {
      cells[i] = new Cell();
    }
  }
}


class HiddenLayer extends Layer {
  Layer prevLayer;
  Layer nextLayer;

  HiddenLayer(int length) {
    super(length);
  }

  HiddenLayer(int length, Layer prevLayer) {
    super(length);
    
    this.prevLayer = prevLayer;

    for (int i = 0; i < this.length; i++) {
      cells[i] = new Neuron(prevLayer.length);
    }
  }

  void setNextLayer(Layer nextLayer) {
    this.nextLayer = nextLayer;
  }

  void forward() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateActivation(prevLayer.cells);
    }
  }

  void backpropagate() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateWeights(prevLayer.cells);
    }
  }

  void updateNodeDeltas() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateNodeDelta(nextLayer.cells);
    }
  }
}


class OutputLayer extends HiddenLayer {
  OutputLayer(int length, Layer prevLayer) {
    super(length);
    
    this.prevLayer = prevLayer;

    for (int i = 0; i < this.length; i++) {
      cells[i] = new OutputNeuron(prevLayer.length);
    }
  }


  void setTarget(int i, float target) {
    OutputNeuron outputNeuron = (OutputNeuron) cells[i];
    outputNeuron.target = target;
  }

  void updateNodeDeltas() {
    for (int i = 0; i < this.length; i++) {
      OutputNeuron outputNeuron = (OutputNeuron) cells[i];
      outputNeuron.updateNodeDelta();
    }
  }
}