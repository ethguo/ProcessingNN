String radString = "3pi";

void setup() {
	println(parseRadToDeg(radString));

	exit();
}

float parseRadToDeg(String radString) {
	String[] parts = radString.split("pi");
	
	printArray(parts);

	if (parts.length == 0) {
		return 180.0;
	}
	else if (parts.length == 1) {
		int num = parseInt(parts[0]);
		return num * 180.0;
	}
	else if (parts[0].equals("")) {
		int den = parseInt(parts[1].substring(1));
		return 180.0 / den;
	}
	else {
		int num = parseInt(parts[0]);
		int den = parseInt(parts[1].substring(1));
		return num * 180.0 / den;
	}


	// ["5", "/12"] ["5"] ["", "/12"] []

	// int num = parseInt(parts[0]);
	// int den = parseInt(parts[1]);

	// return num * 180.0 / den;
}
