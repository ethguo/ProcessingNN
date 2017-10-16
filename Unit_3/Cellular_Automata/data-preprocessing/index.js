const fs = require("fs");
const mnist = require("mnist");

data = []

for (var digit = 0; digit < 10; digit++) {
  digitSet = mnist[digit].set(0, mnist[digit].length);
  console.log(digitSet.length);
  
  // for (var k = 0; k < digitSet.length; k++) {
  //   newOutput = new Array(784).fill(0);
  //   for (var j = 0; j < 10; j++) {
  //     newOutput[j] = digitSet[k]["output"][j];
  //   }
  //   digitSet[k]["output"] = newOutput;
  // }

  data.push(...digitSet);
}

dataObj = {
  "name": "mnist",
  "columns": 784,
  "data": data
}

fs.writeFile("mnist.json", JSON.stringify(dataObj), (err) => {
  if (err) throw err;

  console.log("Done!");
})
