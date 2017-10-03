void setup() {
  size(600,600);
  background(0);
  
  //THERE ARE 3 WAYS TO DECLARE AN ARRAY
  
  //WAY 1: LIST ALL THE VALUES IN ADVANCE USING A { , , } LIST
  int[] x = {90, 83, 10, 70, 12};
  
  //Printing the array
  printArray(x);
  
  
  //Printing its length
  println("Array's length is " + x.length);
  
  //Changing the values using a loop
  for (int i = 0; i < x.length; i++) {
    x[i] += 20;   // could say x[i] = x[i] + 20
  }
  
  //Reprinting the new values
  printArray(x);
  
  //YOUR TURN 1: FIND THE AVERAGE VALUE
  int sum = 0;
  for (int i = 0; i < x.length; i++) {
    sum += x[i];
  }
  int avg = (int) float(sum) / x.length;
  println("Average: " + avg);
  
  
  //YOUR TURN 2: USE A LOOP TO PRINT THE ARRAY IN REVERSE ORDER. HINT: MAKE i GO 4, 3, 2, 1, 0
  for (int i = x.length - 1; i >= 0; i--) {
    println(x[i]);
  }
  
  
  //WAY 2: DECLARE THE SIZE IN ADVANCE BUT NOT THE VALUES...
  
  
  
  //...with the intention of filling in the values later in the program
  
  
  
  //WAY 3: DECLARE THE NAME BUT DON'T COMMIT TO THE SIZE YET
  
  
  //Picking a random size;
  
  
  //Completing the array declaration
  
  
  //Filling the values randomly
  
  
  //exit();
}