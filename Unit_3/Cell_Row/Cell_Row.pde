boolean[] cells;  //Represents the alive-dead states of a single row of n cells.
int n = 300;  //Try changing this
float cellSize;
int padding = 50;  //How many pixels from the left we'll start drawing the first cell.


void setup(){
  size(1000,500);
  noLoop();  //This means draw() only gets called once, not repeatedly, so there's no animation
  
  cells = new boolean[n];  //Sets the size of the array
  cellSize = (width-2*padding)/n;  //Why does this formula guarantee that all n cells will always fit on the screen? 
  setCellValuesRandomly();  //Gives each item in the cells array a random true-false value
  printArray(cells);
}


void draw() {  
  background(255,255,0); //yellow
  float y = height/2;  //The y-value of the top edge of the row
  
  for(int i=0; i<n; i++) {
    float x = padding + i*cellSize;  //The x-value of the left edge of the current cell to be drawn
    
    if (cells[i])  //If the current cell is alive (e.g. the array value is true)...
      fill(255);  //...then we'll color it white.
      
    else
      fill(0);  //...otherwise black
      
    rect(x, y, cellSize, cellSize);  //Draws the current cell
  }
}


//WHEN CALLED, THIS FILLS THE cells ARRAY WITH RANDOM true-false VALUES
void setCellValuesRandomly() {
  for(int i=0; i<n; i++) {
    int randVal = round(random(0,1));
    
    if (randVal == 0)
      cells[i] = false;
      
    else
      cells[i] = true;
  }
}
 