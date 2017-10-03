PrintWriter pw;

void setup() {
  String[] lines = loadStrings("Fractions.txt");
  pw = createWriter("Column sums.txt");
  
  int numRows = lines.length;
  int numCols = lines[0].split("\t").length;
  
  String[][] fractionTable = new String[numRows][numCols];
  
  for (int i = 0; i < lines.length; i++) {
    String[] parts = lines[i].split("\t");
    fractionTable[i] = parts;
  }
  
  for (int col = 0; col < fractionTable[0].length; col++) {
    float columnSum = 0;
    for (int row = 0; row < fractionTable.length; row++) {
      float fraction = parseFraction(fractionTable[row][col]);
      columnSum += fraction;
    }
    String columnSumString = str(smartRound(columnSum, 2));
    println("The sum of column " + str(col) + " is " + columnSumString);
    pw.println(columnSumString);
  }

  pw.close();
}

float parseFraction(String s) {
  int divIndex = s.indexOf("/");
  String sNumerator = s.substring(0, divIndex);
  String sDenominator = s.substring(divIndex + 1);
  
  int numerator = parseInt(sNumerator);
  int denominator = parseInt(sDenominator);
  
  return (float) numerator / denominator;
}

float smartRound(float x, int decimalPlaces) {
  x = x * pow(10, decimalPlaces);
  x = round(x);
  x = x / pow(10, decimalPlaces);
  return x;
}