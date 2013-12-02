/**
 * Simple recursive branching system inspired by mycelium growth, this time in 3D
 * and with added boundary box to constrain growth. Compare with 2D version to see
 * only minor changes were required.
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */
import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

// max segments per branch
int MAX_LEN = 100;
// max recursion limit
int MAX_GEN = 3;
// variance angle for growth direction per time step
float THETA = PI/6;
// branch chance per time step
float BRANCH_CHANCE = 0.05;
// branch angle variance
float BRANCH_THETA = PI/4;

AABB BOUNDS = new AABB(new Vec3D(), new Vec3D(400, 100, 100));

ToxiclibsSupport gfx;
Branch root;

// switch to ensure growth remains in window bounds
boolean doWrap = true;

void setup() {
  size(1280, 600, P3D);
  gfx = new ToxiclibsSupport(this);
  initRoot();
}

void draw() {
  background(0);
  stroke(255,50);
  noFill();
  translate(width/2, height/2, 0);
  rotateX(mouseY * 0.01);
  rotateY(mouseX * 0.01);
  root.grow();
  root.draw();
}

void keyPressed() {
  if (key=='r') {
    initRoot();
  }
}

void initRoot() {
  root = new Branch(new Vec3D(0, 0, 0), new Vec3D(1, 0, 0), 10, THETA, 0);
}

class Branch {
  Vec3D currPos;
  Vec3D dir;
  List<Vec3D> path = new ArrayList<Vec3D>();
  List<Branch> children = new ArrayList<Branch>();

  int generation;
  float speed;
  float theta;

  Branch(Vec3D p, Vec3D d, float s, float t, int g) {
    currPos = p;
    dir = d;
    speed = s;
    theta = t;
    generation = g;
    path.add(p.copy());
  }

  void grow() {
    if (path.size() < MAX_LEN) {
      currPos.addSelf(dir.scale(speed));
      // constrain growth to given world bounds
      currPos.constrain(BOUNDS);
      // randomly rotate around all 3 axes
      dir.rotateX(random(-0.5, 0.5) * THETA)
        .rotateY(random(-0.5, 0.5) * THETA)
          .rotateZ(random(-0.5, 0.5) * THETA);
      path.add(currPos.copy());
      if (generation < MAX_GEN && random(1) < BRANCH_CHANCE) {
        // compute new direction for offspring
        Vec3D branchDir = dir.copy()
          .rotateX(random(-0.5, 0.5) * BRANCH_THETA)
            .rotateY(random(-0.5, 0.5) * BRANCH_THETA)
              .rotateZ(random(-0.5, 0.5) * BRANCH_THETA);
        Branch b = new Branch(currPos.copy(), branchDir, speed * 0.99, theta, generation + 1);
        children.add(b);
      }
    }
    for (Branch c : children) {
      c.grow();
    }
  }

  void draw() {
    gfx.lineStrip3D(path);
    for (Branch c : children) {
      c.draw();
    }
  }
}

