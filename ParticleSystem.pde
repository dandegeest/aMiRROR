class ParticleSystem {
  //Particle image bounds. -1 for
  //endX or endY means the width
  //or height of the used image
  
  int startX = 0, endX = -1;
  int startY = 0, endY = -1;
  
  //The skip variables work well when
  //they're the same value as size
  
  boolean recording = false;
  
  //If true, uses colours from the generated
  //text image. Otherwise, uses particleColour
  boolean imageColour = true;
  color particleColour = color(255);
  
  //Set xSkip, ySkip and particleSize to 1
  //for a mostly perfect image, although
  //this will be very CPU intensive. Even
  //setting them both to 2 can be dramatically
  //easier to render.
  float xSkip = 5;
  float ySkip = 5;
  
  float particleSize = 1;
  color bg = color(0);
  boolean trails = true;

  ArrayList<Particle> particles = new ArrayList();
  boolean finished;

  public ParticleSystem(PImage p) {
    addParticles(p);
    resetParticles();
  }

  private void addParticles(PImage p) {
    float ex = endX != -1 ? endX : p.width;
    float ey = endY != -1 ? endY : p.height;
    for (int x = startX; x<ex; x += xSkip) {  
      for (int y = startY; y<ey; y += ySkip) {
        int pix = p.get(x, y);
        if(pix != bg) {
          particles.add(new Particle(width/2 + x - ex/2, height/2 + y - ey/2, 2.0, random(0.5, 3), imageColour ? pix : particleColour));
        }
      }
    }
  }

  private void resetParticles() {
    background(0);
    float sx = random(width);
    float sy = random(height);
    for (Particle p : particles) {
      p.f = 0;
      p.start.set(sx, sy);
    }
    finished = false;
  }

  public void updateAndDraw(float delta) {
    if (finished)
      return;
    
    pushStyle();
    if (trails) {
      noStroke();
      fill(system.bg, 20);
      rectMode(CORNER);
      rect(0, 0, width, height);
      rectMode(CENTER);
    }
    
    finished = true;
    for (Particle p : particles) {
      p.update(delta);
      p.draw();
      if (p.f < 1) finished = false;
    }
    
    if (xSkip > 1) xSkip -= .2;
    if (ySkip > 1) ySkip -= .2;
    popStyle();
  }
}
