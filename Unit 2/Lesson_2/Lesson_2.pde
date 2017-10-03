/* PARAMETERS */
float markA = 89;
float markB = 70.01;


float getAverage(float a, float b) {
  return (a + b) / 2;
}

String getLetterGrade(float mark) {
  String letterGrade;
  if (mark >= 90) {
    letterGrade = "A";
  }
  else if (mark >= 80) {
    letterGrade = "B";
  }
  else if (mark >= 70) {
    letterGrade = "C";
  }
  else if (mark >= 60) {
    letterGrade = "D";
  }
  else {
    letterGrade = "F";
  }
  return letterGrade;
}

void setup() {
  float mark = getAverage(markA, markB);
  println("Average mark: " + mark);

  String letterGrade = getLetterGrade(mark);
  println("Letter grade: " + letterGrade);
}