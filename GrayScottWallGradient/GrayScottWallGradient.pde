/**
 * Spatial manipulation of Gray-Scott coefficients using circular gradient.
 * Code based on "GrayScottCustom" example of toxiclibs distribution.
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */

import toxi.sim.grayscott.*;
import toxi.math.*;

import toxi.color.*;

int NUM_ITERATIONS = 10;
GrayScott gs;

void setup() {
  size(256, 256);
  float safeRadius = sqrt(sq(width/2) + sq(height/2)) * 0.6666;
  gs=new RadialGradientGrayScott(width, height, false, safeRadius, -0.02);
  gs.setCoefficients(0.024, 0.077, 0.12, 0.06);
}

void draw() {
  if (mousePressed) {
    gs.setRect(mouseX, mouseY, 20, 20);
  }
  loadPixels();
  // update the simulation a few time steps
  for (int i=0; i<NUM_ITERATIONS; i++) {
    gs.update(1);
  }
  // read out the V result array
  // and use tone map to render colours
  for (int i=0; i<gs.v.length; i++) {
    // if gs.v[i] is less than 50% saturated: use black, else white
    pixels[i] = color(gs.v[i] < 0.25 ? 0 : 255);
  }  
  updatePixels();
}

void keyPressed() {
  gs.reset();
}

class RadialGradientGrayScott extends GrayScott {

  float safeRadius;
  float damping;
  
  public RadialGradientGrayScott(int w, int h, boolean tiling, float safeRadius, float damping) {
    super(w, h, tiling);
    this.safeRadius = safeRadius;
    this.damping = damping;
  }

  // F coefficient is depending on XY distance from center
  // we assume all points with min. distance of safeRadius are using
  // original F value, but closer points will have their F based on
  // a gradient with strongest damping applied at the center of
  // the simulation space...
  public float getFCoeffAt(int x, int y) {
    float dx = x - this.width/2;
    float dy = y - this.height/2;
    float mag = sqrt(dx * dx + dy * dy);
    mag = min(mag, safeRadius);
    mag = 1 - mag / safeRadius;
    return f + mag * damping;
  }

  public float getKCoeffAt(int x, int y) {
    return k;
  }
}

