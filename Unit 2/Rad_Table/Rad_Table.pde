static char c_pi = '\u03C0';

String thetaIncrementString = "pi/12";

void setup() {
	int numerator = getNumerator(thetaIncrementString);
	int denominator = getDenominator(thetaIncrementString);

	float thetaIncrement = numerator * PI / denominator;

	radTable(numerator, denominator);

	exit();
}

int getNumerator(String radString) {
	int piIndex = radString.indexOf("pi");

	if (piIndex == 0) {
		return 1;
	}
	else {
		String numString = radString.substring(0, piIndex);
		return parseInt(numString);
	}
}

int getDenominator(String radString) {
	int piIndex = radString.indexOf("pi");

	if (piIndex + 2 == radString.length()) {
		return 1;
	}
	else {
		String denString = radString.substring(piIndex + 3);
		return parseInt(denString);
	}
}

void radTable(int deltaNumerator, int denominator) {
	println(" t\t\t sin t\t cos t");
	float theta = 0;
	int numerator = 0;
	while (theta < 2 * PI) {
		theta = numerator * PI / denominator;
		print(radFraction(numerator, denominator));
		printTableValues(theta);
		numerator += deltaNumerator;
	}
}

String radFraction(int numerator, int denominator) {
	if (denominator == 0)
		throw new IllegalArgumentException("Denominator cannot be zero");

	if (numerator == 0)
		return "0";

	// Reduce fraction
	for (int i = min(numerator, denominator); i > 1; i--) {
		if (numerator % i == 0 && denominator % i == 0) {
			numerator /= i;
			denominator /= i;
			break;
		}
	}

	// Remove 1s and 0s
	String returnString;
	if (numerator == 1)
		returnString = "pi";
	else
		returnString = str(numerator) + "pi";

	if (denominator != 1)
		returnString += "/" + str(denominator);

	return returnString;
}

void printTableValues(float theta) {
	print(" \t");
	print(nfs(sin(theta), 1, 3));
	print(" \t");
	print(nfs(cos(theta), 1, 3));
	println();
}