class Layer {
  int length;
  Cell[] cells;

  Layer(int length) {
    this.length = length;
    cells = new Cell[length];
  }

  void setActivations(float activation) {
    for (int i = 0; i < this.length; i++) {
      cells[i].activation = activation;
    }
  }

  void setActivations(float[] activations) {
    for (int i = 0; i < this.length; i++) {
      float activation = activations[i];
      cells[i].activation = activation;
    }
  }

  void setActivations(JSONArray activations) {
    for (int i = 0; i < this.length; i++) {
      float activation = activations.getFloat(i);
      cells[i].activation = activation;
    }
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
  HiddenLayer(int length, Layer prevLayer) {
    super(length);

    for (int i = 0; i < this.length; i++) {
      cells[i] = new Neuron(prevLayer, learningRate, biasLearningRate);
    }
  }

  void setNextLayer(Layer nextLayer) {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.setNextLayer(nextLayer);
    }
  }

  void setRandomWeights(float stdDev) {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.setRandomWeights(stdDev);
    }
  }

  void forward() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateActivation();
    }
  }

  void backpropagate() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateWeights();
    }
  }

  void updateNodeDeltas() {
    for (int i = 0; i < this.length; i++) {
      Neuron neuron = (Neuron) cells[i];
      neuron.updateNodeDelta();
    }
  }
}


class OutputLayer extends HiddenLayer {
  OutputLayer(int length, Layer prevLayer) {
    super(length, prevLayer);

    for (int i = 0; i < this.length; i++) {
      cells[i] = new OutputNeuron(prevLayer, learningRate, biasLearningRate);
    }
  }

  void setTargets(float[] targets) {
    for (int i = 0; i < this.length; i++) {
      float target = targets[i];
      ((OutputNeuron) cells[i]).target = target;
    }
  }

  void setTargets(JSONArray targets) {
    for (int i = 0; i < this.length; i++) {
      float target = targets.getFloat(i);
      ((OutputNeuron) cells[i]).target = target;
    }
  }

  void updateNodeDeltas() {
    for (int i = 0; i < this.length; i++) {
      ((OutputNeuron) cells[i]).updateNodeDelta();
    }
  }
}