/**
 * Interpreting a grayscale image as elevation matrix for a 3D terrain.
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */
 
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

TriangleMesh mesh;
ToxiclibsSupport gfx;

void setup() {
  size(640, 480, P3D);
  // load image from data folder
  PImage img = loadImage("rd.png");
  // create a terrain instance of same size as image
  // each pixel/cell will have a size of 10 units
  Terrain terrain = new Terrain(img.width, img.height, 10);
  // create an array for elevation values 
  float[] el = new float[img.width * img.height];
  // iterate over all pixels in image
  for(int i=0; i<el.length; i++) {
    // use inverted pixel brightness as elevation
    el[i] = (255 - brightness(img.pixels[i])) * 0.15;
  }
  // assign elevation array to terrain
  terrain.setElevation(el);
  // create mesh
  mesh = new TriangleMesh();
  // create watertight mesh with base plate at elevation -10
  terrain.toMesh(mesh,-10);
  // save result mesh as OBJ format in sketch folder
  mesh.saveAsOBJ(sketchPath("terrain.obj"));
  // attach drawing utils
  gfx = new ToxiclibsSupport(this);
}


void draw() {
  background(0);
  lights();
  translate(width/2,height/2,0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);
  noStroke();
  gfx.mesh(mesh);
}
