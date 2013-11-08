/**
 * <p>CustomGrayScott shows how to extend the GrayScott class to create spatial
 * differences in behaviour (i.e. different patterns) through manipulating the
 * F and K coefficients of the reaction diffusion. The demo also uses the
 * ColorGradient & ToneMap classes of the colorutils package to create a
 * tone map for rendering the results of the Gray-Scott reaction-diffusion.</p>
 *
 * <p><strong>Usage:</strong><ul>
 * <li>click + drag mouse to draw dots used as simulation seed</li>
 * <li>press any key to reset</li>
 * </ul></p>
 *
 * <p>UPDATES:<ul>
 * <li>2011-01-18 using ToneMap.getToneMappedArray()</li>
 * </ul></p>
 */

/* 
 * Copyright (c) 2009 Karsten Schmidt
 * 
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

import toxi.sim.grayscott.*;
import toxi.math.*;

import toxi.color.*;

int NUM_ITERATIONS = 10;
float maxMag;

GrayScott gs;

void setup() {
  size(256,256);
  gs=new PatternedGrayScott(width,height,false);
  gs.setCoefficients(0.024, 0.077,0.12,0.06);
  float dx = width/2;
  float dy = height/2;
  maxMag = sqrt(dx * dx + dy * dy) * 0.6666;
}

void draw() {
  if (mousePressed) {
    gs.setRect(mouseX, mouseY,20,20);
  }
  loadPixels();
  // update the simulation a few time steps
  for(int i=0; i<NUM_ITERATIONS; i++) {
    gs.update(1);
  }
  // read out the V result array
  // and use tone map to render colours
  for(int i=0; i<gs.v.length; i++) {
    // if gs.v[i] is less than 50% saturated use black, else white
    pixels[i] = color(gs.v[i]<0.25 ? 0 : 255);  
  }  
  updatePixels();
}

void keyPressed() {
  gs.reset();
}

// using inheritance and overwriting of 2 supplied adapter methods,
// we can customize the standard homogenous behaviour and create new outcomes.
class PatternedGrayScott extends GrayScott {
  public PatternedGrayScott(int w, int h, boolean tiling) {
    super(w,h,tiling);
  }

  // we use the x position to divide the simulation space into columns
  // of alternating behaviors
  public float getFCoeffAt(int x, int y) {
    float dx = x - this.width/2;
    float dy = y - this.height/2;
    float mag = sqrt(dx * dx + dy * dy);
    mag = min(mag, maxMag);
    mag = (1- mag/maxMag);
    return f - mag * 0.02;
  }

  // we use the y position to create a gradient of varying values for
  // the simulation's K coefficient
  public float getKCoeffAt(int x, int y) {
    return k;
  }
}
