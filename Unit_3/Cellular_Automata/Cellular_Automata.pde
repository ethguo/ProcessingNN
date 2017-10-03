color[][] cells;
int n = 20;
float cellSize;
float padding = 0;
int framerate = 10;

void setup(){
  size(800, 800);
  frameRate(framerate);

  colorMode(HSB, 1.0, 1.0, 1.0);

  cells = new color[n][n];
  cellSize = (width-2*padding)/n;

  setCellValuesRandomly();
  drawCells();

}

void draw() {
  // background(2.0/3, 1.0, 1.0);
  background(0);

  // updateCells();
  drawCells();
}

void updateCells() {
  color[][] nextCells = new color[n][n];

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {

    }
  }
  

  // int liveNeighbours;
  //     liveNeighbours = countLiveNeighbours(i, j);

  //     if (cells[i][j] == 1) {
  //       if (liveNeighbours == 2 || liveNeighbours == 3)
  //         nextCells[i][j] = 1;
  //       else
  //         nextCells[i][j] = 0;
  //     }
  //     else {
  //       if (liveNeighbours == 3)
  //         nextCells[i][j] = 1;
  //       else
  //         nextCells[i][j] = 0;
  //     }
  //   }
  // }

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      cells[i][j] = nextCells[i][j];
    }
  }
}

void drawCells() {
  float y = padding;
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = padding + j*cellSize;

      fill(cells[i][j]);
        
      rect(x, y, cellSize, cellSize);
    }
    y += cellSize;
  }
}

int countLiveNeighbours(int i, int j) {
  int liveNeighbours = 0;
  for (int deltai = -1; deltai <= 1; deltai++) {
    for (int deltaj = -1; deltaj <= 1; deltaj++) {
      if (deltai != 0 || deltaj != 0) {
        try {
          liveNeighbours += cells[i + deltai][j + deltaj];
        }
        catch (ArrayIndexOutOfBoundsException e) { }
      }
    }
  }
  return liveNeighbours;
}

void setCellValuesRandomly() {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = random(0,1);

      cells[i][j] = color(x, 0.25, 0.5);
    }
  }
}

 