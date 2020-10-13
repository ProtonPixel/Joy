class Line {
  PVector[] vertices;
  int points, period;
  float ramp, scl, radius;
  float[] ampNoise;
  OpenSimplexNoise noirel; // I'm using OpenSimplexNoise, a library external to 🅱rocessing
  PVector begin, middle, end;
  color colour;

  Line(PVector begin, PVector end) {
    noirel = new OpenSimplexNoise();
    this.begin = begin.copy();
    this.end = end.copy();

    middle = new PVector(.5 * (end.x + begin.x), begin.y);

    points = 30;
    scl = (end.x - begin.x) / points;
    ramp = height / map(begin.y, height / 2, 3 * height / 4, 5, 2.75);

    vertices = new PVector[points];

    ampNoise = new float[points];
    for (int i = 0; i < ampNoise.length; i++)
      ampNoise[i] = random(1000);

    vertices[0] = begin.copy();
    vertices[vertices.length - 1] = end.copy();

    for (int i = 0; i < vertices.length; i++) {
      float x, y;

      x = begin.x + i * scl;
      y = begin.y;
      vertices[i] = new PVector(x, y);
    }

    colour = color(15, 5, 2);
    period = 180;
    radius = 1.2;
  }

  void run() {
    update();
    show();
  }

  void show() {
    stroke(225, 255, 200);
    strokeWeight(3);
    fill(colour);

    beginShape();

    vertex(vertices[0].x, vertices[0].y);
    for (int i = 1; i < vertices.length - 1; i++) {
      float xc, yc;

      xc = .5 * (vertices[i].x + vertices[i + 1].x);
      yc = .5 * (vertices[i].y + vertices[i + 1].y);

      quadraticVertex(vertices[i].x, vertices[i].y, xc, yc);
    }
    vertex(vertices[vertices.length - 1].x, vertices[vertices.length - 1].y);

    endShape();
  }

  void update() {
    for (int i = 1; i < vertices.length - 1; i++) {

      float dist, variance, amp;

      dist = abs(begin.x + i * scl - middle.x);
      variance = max(middle.x - ramp - dist, 0);
      amp = map((float)noirel.eval(ampNoise[i], radius * cos(TWO_PI * frameCount / period), radius * sin(TWO_PI * frameCount / period)), -1, 1, 0, 1) * variance;

      vertices[i].y = middle.y - amp;
    }
  }
}
