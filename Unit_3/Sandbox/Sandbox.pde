void setup() {
  float a1 = radians(30);
  float a2 = radians(60);

  // float a1mod = a1 % 2*PI;
  // float a2mod = a2 % 2*PI;

  float a = a1 - a2;

  if (a > PI)
    a -= 2*PI;
  else if (a < -PI)
    a += 2*PI;

  println(degrees(a1));
  println(degrees(a2));
  println(degrees(a));

  exit();
}