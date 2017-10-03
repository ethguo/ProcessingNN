void setup() {
  String p;
  
  p = "(1367.2, -54.999)";
  println("The point " + p + " is " + getLocationFromOrderedPair(p));

  p = "(0, -4)"; 
  println("The point " + p + " is " + getLocationFromOrderedPair(p));
  
  p = "(62.5, 0.03)"; 
  println("The point " + p + " is " + getLocationFromOrderedPair(p));

  p = "(28.541, 150.7)"; 
  println("The point " + p + " is " + getLocationFromOrderedPair(p));

  exit();
}


String getLocationFromOrderedPair( String pair ) {
  int iOpenParen = pair.indexOf("(");
  int iComma = pair.indexOf(",");
  int iCloseParen = pair.indexOf(")");

  String sxComponent = pair.substring(iOpenParen + 1, iComma);
  int iyComponent = iComma;
  while (pair.charAt(++iyComponent) == ' ');
  
  String syComponent = pair.substring(iyComponent, iCloseParen);

  float x = parseFloat(sxComponent);
  float y = parseFloat(syComponent);

  return getLocation(x, y);
}


String getLocation(float x, float y) {
  if ( x==0 && y==0 ) 
    return "at the origin";
   
  else if ( x==0 ) 
    return "on the y-axis";
   
  else if ( y==0 ) 
    return "on the x-axis";
   
  else if ( x>0 && y>0 ) 
    return "in quadrant 1";
   
  else if ( x<0 && y>0 ) 
    return "in quadrant 2";
   
  else if ( x<0 && y<0 ) 
    return "in quadrant 3";
   
  else 
    return "in quadrant 4";
}