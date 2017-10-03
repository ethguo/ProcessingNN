int[][] cells;
int n = 100;
float cellSize;
float padding = 0;
int framerate = 10;

void setup(){
  size(800, 800);
  cellSize = (width-2*padding)/n;
  cells = new int[n][n];
  frameRate(framerate);

  setCellValuesRandomly();
  drawCells();

}

void draw() {
  background(0,0,255);

  updateCells();
  drawCells();
}

void drawCells() {
  float y = padding;
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = padding + j*cellSize;
      if (cells[i][j] == 1)
        fill(255);
      else
        fill(0);
        
      rect(x, y, cellSize, cellSize);
    }
    y += cellSize;
  }
}

void updateCells() {
  int liveNeighbours;
  int[][] nextCells = new int[n][n];
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      liveNeighbours = countLiveNeighbours(i, j);

      if (cells[i][j] == 1) {
        if (liveNeighbours == 2 || liveNeighbours == 3)
          nextCells[i][j] = 1;
        else
          nextCells[i][j] = 0;
      }
      else {
        if (liveNeighbours == 3)
          nextCells[i][j] = 1;
        else
          nextCells[i][j] = 0;
      }
    }
  }

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      cells[i][j] = nextCells[i][j];
    }
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
      
      if (x < 0.3)
        cells[i][j] = 1;
        
      else
        cells[i][j] = 0;
    }
  }
}

 