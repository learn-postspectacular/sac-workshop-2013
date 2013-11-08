import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

TriangleMesh mesh;
ToxiclibsSupport gfx;

void setup() {
  size(640, 480, P3D);
  PImage img = loadImage("rd.png");
  Terrain terrain = new Terrain(img.width, img.height, 16);
  float[] el = new float[img.width * img.height];
  for(int i=0; i<el.length; i++) {
    el[i] = (255 - brightness(img.pixels[i])) * 0.25;
  }  
  terrain.setElevation(el);
  // create mesh
  mesh = new TriangleMesh();
  terrain.toMesh(mesh,-10);
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
