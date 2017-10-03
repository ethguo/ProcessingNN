JSONObject data;

void setup() {
  size(400, 400);
  data = loadJSONObject("https://httpbin.org/get");
  print(data);
}

void draw() {
}