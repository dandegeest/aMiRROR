float detectMotion(Capture c, PImage p, int threshold) {
  c.loadPixels();
  p.loadPixels();
  
  int motionPixelCount = 0;  // Reset motion count
  
  // Loop through pixels to check for motion
  for (int i = 0; i < c.pixels.length; i++) {
    color current = c.pixels[i];
    color previous = p.pixels[i];
    
    float diff = dist(red(current), green(current), blue(current),
                      red(previous), green(previous), blue(previous));
    
    if (diff > threshold) {
      motionPixelCount++;  // Count motion pixels
    }
  }
  
  // Calculate motion percentage
  float motionPercentage = (float) motionPixelCount / c.pixels.length * 100;
  
  //println(motionPercentage);
  return motionPercentage;
}

PImage resizeAndCrop(PImage img, int newW, int newH) {
  // Resize while maintaining aspect ratio
  float aspectRatio = float(img.width) / img.height;
  int tempW = newW, tempH = newH;
  
  if (aspectRatio > 1) { // Landscape image
    tempW = int(newH * aspectRatio);
  } else { // Portrait image
    tempH = int(newW / aspectRatio);
  }
  
  PImage temp = img.copy();
  temp.resize(tempW, tempH);
  
  // Crop center
  int cropX = (temp.width - newW) / 2;
  int cropY = (temp.height - newH) / 2;
  
  return temp.get(cropX, cropY, newW, newH);
}
