
// #1. locations stores the current (x, y) position of each star. speeds stores which way each star is moving. 
PVector[] locations;
PVector[] speeds;

int n = 5000;   // #2. n is the number of stars to draw.
float s = 0.75; // #3. s is the speed that each star moves at.


// #4. setup initializes the locations and speeds arrays and fills them with appropriate values.
void setup(){
  size(1000, 1000);
  stroke(255);

  // #5. creates the locations and speeds arrays, with the specified size.
  locations = new PVector[n];
  speeds = new PVector[n];
  
  
  for(int i=0; i<n; i++){
    float x = random(0, width);
    float y = random(0, height);
    locations[i] = new PVector(x, y);   // #6.  Initializes each star at a random position on the screen. 
    speeds[i] = new PVector(0, 0);      // #7.  Initializes each star with zero speed.
  } 
}


// #8. draw redraws the stars every frame, and updates their position to move them towards the mouse cursor.
void draw(){
    background(0);
    
    // #9. Loops through and updates the position of every star.
    for(int i=0; i<n; i++){
      
      // #10. Draws the star in its current (x, y) location.
      point( locations[i].x, locations[i].y ); 
      
      // #11. Moves the star in the direction stored in speeds.
      locations[i].x += speeds[i].x;
      locations[i].y += speeds[i].y;
      
      // #12. Sets the horizontal and vertical speed of the star to be moving towards the mouse cursor.
      if( mouseX > locations[i].x ) 
        speeds[i].x = s;
      
      else
        speeds[i].x = -s;

      if( mouseY > locations[i].y ) 
        speeds[i].y = s;
        
      else
        speeds[i].y = -s;
    }
}


// #13. When the mouse is clicked, randomly distribute the stars all over the screen
void mouseClicked() {
  for(int i=0; i<n; i++){
    locations[i].x = random(0, width);
    locations[i].y = random(0, height);
  } 
}