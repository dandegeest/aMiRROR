import processing.video.*;

Capture cam;
Timer capTimer;
PImage capImage = null;
PImage prevFrame;
boolean ready = false;

ParticleSystem system;
int slideAlpha;
int slideAlphaMax = 50;
float pXSkip = 5;
float pYSkip = 5;
int scanY = 15;

PFont mocha;

enum State { CAPTURE, ANIMATE, DISPLAY };

State state = State.CAPTURE;

void setup() {
  size(720, 1280);
  cam = new Capture(this);
  cam.start();
  prevFrame = createImage(cam.width, cam.height, RGB);
  capTimer = new Timer();
  capTimer.interval = 0;
  capTimer.tfx = (timer) -> {
    if (ready) {
      timer.stop();
      if (state == State.CAPTURE) {
        capture();
        state = State.ANIMATE;
      }
      if (state == State.DISPLAY) {
        capImage = null;
        ready = false;
        state = State.CAPTURE;
      }
    }
  };

  mocha = createFont("mochalatte-font/Mochalatte-JRorB.ttf", 48);
  textFont(mocha);
  
  println("Camera", cam.width, cam.height);
}

void draw() {
  timer(capTimer);
  
  switch (state) {
    case CAPTURE:
      updateCapture();
    break;
    case ANIMATE:
      system.updateAndDraw(1f/60);
      if (system.finished) {
        state = State.DISPLAY;
      }
    break;
    case DISPLAY:
      image(capImage, 0, 0);
      fill(255, 255, 255, 220);
      textSize(48);
      textAlign(CENTER);
      text("Wave to Start Over", 0, 0, width, height);
      updateCapture();
    break;
  }
}

void updateCapture() {
  if (!cam.available())
    return;
      
  cam.read();
    
  if (ready) {
    if (state == State.CAPTURE) {
      background(0);
      image(cam, (width - cam.width)/2, 0);
      
      if (capTimer.interval == 0) {
        fill(250, 0, 0, 220);
        textSize(48);
        textAlign(CENTER, CENTER);
        text("Wave to Take Picture", 0, 0, width, cam.height);
      }
      else {
        noFill();
        stroke(250, 0, 0, 220);
        strokeWeight(10);
        rect((width - cam.width)/2 + 5, 5, cam.width - 10, cam.height - 10, 5);
        fill(250, 0, 0, 220);
        textSize(96);
        textAlign(CENTER, CENTER);
        int tminus = int(3 - (millis() - capTimer.lastFire)/1000);
        text(""+(tminus), 0, 0, width, cam.height);      
      }      
    }
    
    if (detectMotion(cam, prevFrame, 20) > 40) {
      capTimer.start(state == State.CAPTURE ? 3000 : 500);
    }
  }
  
  //Save last frame
  prevFrame.copy(cam, 0, 0, cam.width, cam.height, 0, 0, prevFrame.width, prevFrame.height);
  ready = true;
}

// Capture an image when a key is pressed
void capture() {
  capImage = resizeAndCrop(cam.get().copy(), 720, 1280);
  capImage.resize(width, 0);
  slideAlpha = 0;
  system = new ParticleSystem(capImage);
  system.xSkip = pXSkip;
  system.ySkip = pYSkip;

}

void mousePressed() {
}
