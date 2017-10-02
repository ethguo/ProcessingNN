boolean[][] cells;
int n = 10;
float cellSize;
float padding = 50;
int blinksPerSecond = 3;

void setup(){
  size(1000,1000);
  cellSize = (width-2*padding)/n;
  cells = new boolean[n][n];
  frameRate( blinksPerSecond );
}

void draw() {
  background(0,0,255);
  setCellValuesRandomly();
  float y = padding;
  
  for(int i=0; i<n; i++) {
    for(int j=0; j<n; j++) {
      float x = padding + j*cellSize;
      if (cells[i][j])
        fill(255);
      else
        fill(0);
        
      rect(x, y, cellSize, cellSize);
    }
    y += cellSize;
  }
}


void setCellValuesRandomly() {
  for(int i=0; i<n; i++) {
    
    for(int j=0; j<n; j++) {      
      int x = round(random(0,1));
      
      if (x == 0)
        cells[i][j] = false;
        
      else
        cells[i][j] = true;
    }
  }
}

 