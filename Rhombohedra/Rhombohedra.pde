import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

ToxiclibsSupport gfx;
RhomboGroup rg;

float THETA = PI/3;
float L = 50;
int MAX_GENERATION = 3;

void setup() {
  size(600, 600, P3D);
  gfx = new ToxiclibsSupport(this);
  rg = new RhomboGroup(new Vec2D(300, 300), 0);
}

void draw() {
  background(0);
  stroke(255);
  //noFill();
  //translate(width/2, height/2, 0);
  //rotateY(mouseX * 0.01);
  //float len = map(mouseX, 0, width, 20, 200);
  rg.draw();
}

class RhomboGroup {
  Rhombohedron a, b, c;
  RhomboGroup ch1, ch2, ch3;
  Vec2D seedPos;
  int gen;

  RhomboGroup(Vec2D sp, int gen) {
    println(sp+" " + gen);
    seedPos = sp;
    this.gen = gen;
    a = new Rhombohedron(sp, L, THETA, 0);
    b = new Rhombohedron(sp, L, THETA, PI*2/3);
    c = new Rhombohedron(sp, L, THETA, -PI*2/3);

    Vec2D n1 = new Rhombohedron(sp, L, THETA, PI/3).poly.get(2);
    Vec2D n2 = new Rhombohedron(sp, L, THETA, PI).poly.get(2);
    Vec2D n3 = new Rhombohedron(sp, L, THETA, -PI/3).poly.get(2);
    if (gen < MAX_GENERATION) {
      ch1 = new RhomboGroup(n1, gen+1);
      ch2 = new RhomboGroup(n2, gen+1);
      ch3 = new RhomboGroup(n3, gen+1);
    }
  }

  void draw() {
    stroke(255-gen*30);
    a.draw(); 
    b.draw(); 
    c.draw();
    if (ch1 != null) {
      ch1.draw();
      ch2.draw();
      ch3.draw();
    }
  }
}

class Rhombohedron {
  Vec2D seedPos;
  float len;
  float theta;
  float phi;
  Polygon2D poly;

  Rhombohedron(Vec2D p, float l, float t, float phi) {
    seedPos = p;
    len = l;
    theta = t;
    this.phi = phi;
    poly = new Polygon2D();
    poly.add(seedPos);
    Vec2D delta = new Vec2D(len, 0).rotate(phi);
    Vec2D m = seedPos.add(delta);
    poly.add(m);
    delta.rotate(theta);
    Vec2D n = m.add(delta);
    poly.add(n);
    delta.set(-len, 0).rotate(phi);
    Vec2D o = n.add(delta);
    poly.add(o);
  }

  void draw() {
    gfx.polygon2D(poly);
  }
}

