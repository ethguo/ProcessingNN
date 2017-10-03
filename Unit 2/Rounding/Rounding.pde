void setup() {
	float x = random(100);
	for (int d = 0; d < 10; d++) {
		println(roundAny(x, d));
	}

	exit();
}

float roundAny(float x, int d) {
	x = x * pow(10, d);
	x = round(x);
	// x = x * pow(10, -d); floating point imprecision
	x = x / pow(10, d);
	return x;
}