/**
 * Recursive plane tiling inspired by crystal growth formations.
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */
import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

ToxiclibsSupport gfx;
RhomboGroup rg;

float THETA = PI/3;
float L = 50;
int MAX_GEN = 3;

void setup() {
  size(600, 600, P3D);
  gfx = new ToxiclibsSupport(this);
  rg = new RhomboGroup(new Vec2D(300, 300), 0);
}

void draw() {
  background(0);
  stroke(0);
  rg.draw();
}

class RhomboGroup {
  Rhombohedron a, b, c;
  RhomboGroup ch1, ch2, ch3;
  Vec2D seedPos;
  int gen;

  RhomboGroup(Vec2D sp, int gen) {
    seedPos = sp;
    this.gen = gen;
    a = new Rhombohedron(sp, L, THETA, 0);
    b = new Rhombohedron(sp, L, THETA, THETA*2);
    c = new Rhombohedron(sp, L, THETA, -THETA*2);

    if (gen < MAX_GEN) {
      Vec2D n1 = new Rhombohedron(sp, L, THETA, THETA).poly.get(2);
      Vec2D n2 = new Rhombohedron(sp, L, THETA, PI).poly.get(2);
      Vec2D n3 = new Rhombohedron(sp, L, THETA, -THETA).poly.get(2);
      ch1 = new RhomboGroup(n1, gen+1);
      ch2 = new RhomboGroup(n2, gen+1);
      ch3 = new RhomboGroup(n3, gen+1);
    }
  }

  void draw() {
    fill(255 - gen * 30);
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

  Polygon2D poly;

  Rhombohedron(Vec2D seedPos, float len, float theta, float phi) {
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

