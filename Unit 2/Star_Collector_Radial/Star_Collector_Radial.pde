float[] radii;
float[] angles;
float[] radialSpeeds;
float[] angularSpeeds;
int n = 5000;
float maxRadialSpeed = 0.5; //Next try 0.5 with maxAngularSpeed=0.0.  Then try 0.5 with maxAngularSpeed=0.005
float maxAnglularSpeed = 0.002; //Try 0.005
float xC, yC;

void setup(){
  size(1000,1000);
  stroke(255, 255, 0);

  xC = width/2;
  yC = height/2;
  
  radii = new float[n];
  angles = new float[n];
  radialSpeeds = new float[n];
  angularSpeeds = new float[n];
  
  for(int i=0; i<n; i++){
    radii[i] = random(0, width/2);
    angles[i] = random(0, 2*PI);
    
    radialSpeeds[i] = 0;
    angularSpeeds[i] = 0;
  } 
}


void draw(){
    background(0);
    float x, y;
    float mouseAngle = atan2( yC-mouseY, mouseX-xC ); //atan2(a, b) is the inverse tangent of a/b
    
    if ( mouseAngle < 0 )
      mouseAngle += 2*PI; //needed because atan2 ranges from -3.14 to +3.14 rather than 0 to 6.28
                          //and we want the principal angle to be positive 
      
    text("mouse angle = " + mouseAngle, 100, 100);
    
    for(int i=0; i<n; i++) { //for each point...
    
      //radii[i] += random(-1, 1);
      //angles[i] += random(-0.01, 0.01);
    
      x = xC + radii[i] * cos(angles[i]);  //calculate the point's (x,y) coordinates using its known radius and angle
      y = yC - radii[i] * sin(angles[i]);
      
      point(x, y); //draw the point
      
      radii[i] += radialSpeeds[i];  //update the point's radius and angle using its radial speed and angular speed
      angles[i] += angularSpeeds[i];
      
      if( dist(mouseX, mouseY, xC, yC ) > radii[i]) //update the speeds based on where the mouse is
        radialSpeeds[i] = maxRadialSpeed;
        
      else
        radialSpeeds[i] = -maxRadialSpeed;

      if( mouseAngle > angles[i] ) 
        angularSpeeds[i] = maxAnglularSpeed;
        
      else
        angularSpeeds[i] = -maxAnglularSpeed;
    }
}


void mouseClicked() {
  for(int i=0; i<n; i++) {
    radii[i] = random(0, width/2);
    angles[i] = random(0, 2*PI);
    radialSpeeds[i] = 0;
    angularSpeeds[i] = 0;
  }
}