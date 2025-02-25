class Particle {
  PVector start, anchor, end;
  PVector current = new PVector();
  float f = 0;
  float size;
  float duration;
  color c;

  public Particle(float ex, float ey, float size, float d, color c) {
    this.start = new PVector(width/2, height/2);
    //float a = round(random(16)) * QUARTER_PI * 0.5;
    //this.anchor = new PVector(cos(a) * 300 + width/2, sin(a) * 300 + height/2);
    float a = random(TWO_PI);
    this.anchor = new PVector(cos(a) * random(100, 800) + width/2, sin(a) * random(100, 800) + height/2);
    this.end = new PVector(ex, ey);
    this.size = size;
    duration = d;
    this.c = c;
  }

  public void update(float delta) {
    if (f >= 1) {
      f = 1;
      return;
    }
    f += delta/duration;
    if (f > 1) {
      f = 1;
    }
    b();
  }

  private float interpolate(float f) {
    return 1 - pow(1 - f, 2);
  }

  private void b() {
    float fi = interpolate(f);
    float x = lerp(lerp(start.x, anchor.x, fi), lerp(anchor.x, end.x, fi), fi);
    float y = lerp(lerp(start.y, anchor.y, fi), lerp(anchor.y, end.y, fi), fi);
    current.set(x, y);
  }

  public void draw() {
    //rect() is a LOT faster than ellipse()
    //and point()
    noFill();
    stroke(c);
    strokeWeight(f);
    //rect(current.x, current.y, system.xSkip, system.ySkip);
    rect(current.x, current.y, 5, 5);
  }
}
