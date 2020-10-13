Line[] lines;
float radius;
color bg, inside;

void setup() {
  size(600, 600);

  lines = new Line[8];
  radius = 200;

  float step = 25;
  for (int i = 0; i < lines.length; i++) {
    float x, y;
    PVector begin, end;

    y = height / 2 + i * step;
    x = width / 2 - sqrt(radius * radius - (y - height / 2) * (y - height / 2));
    begin = new PVector(x, y);
    x = width / 2 + sqrt(radius * radius - (y - height / 2) * (y - height / 2));
    end = new PVector(x, y);

    lines[i] = new Line(begin, end);
  }

  bg = color(50, 15, 100);
  inside = color(15, 5, 2);
}

void draw() {
  background(bg);
  radialGradient(new PVector(width / 2, height / 2), 275, color(70, 255, 100), bg);

  fill(inside);
  ellipse(width / 2, height / 2, radius * 2, radius * 2);

  drawNoise();

  for (Line line : lines)
    line.run();

  noFill();
  strokeWeight(20);
  stroke(10);
  ellipse(width / 2, height / 2, radius * 2, radius * 2);
}

void radialGradient(PVector position, float radius, color color1, color color2) {
  loadPixels();

  for (int x = 0; x < width; x++) 
    for (int y = 0; y < height; y++) {
      float dist = dist(position.x, position.y, x, y);
      if (dist <= radius) {
        pixels[x + width * y] = lerpColor(color1, color2, map(dist, 0, radius, 0, 1));
      }
    }

  updatePixels();
}

void drawNoise() {
  loadPixels();
  for (int x = 0; x < width; x++)
    for (int y = 0; y < height; y++) {
      if (dist(width / 2, height / 2, x, y) < radius && y < height / 2)
        pixels[x + y * width] = random(1) < .75 ? color(25, 5, 10) : color(100, 230, 255);
    }
  updatePixels();
}
