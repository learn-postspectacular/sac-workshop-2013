/**
 * Simple recursive branching system inspired by mycelium growth
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
float BRANCH_THETA = PI/3;

ToxiclibsSupport gfx;
Branch root;

// switch to ensure growth remains in window bounds
boolean doWrap = true;

void setup() {
  size(1280, 600);
  gfx = new ToxiclibsSupport(this);
  root = new Branch(new Vec2D(0, height/2), new Vec2D(1, 0), 10, THETA, 0);
}

void draw() {
  background(0);
  stroke(255);
  noFill();
  root.grow();
  root.draw();
}

class Branch {
  Vec2D currPos;
  Vec2D dir;
  List<Vec2D> path = new ArrayList<Vec2D>();
  List<Branch> children = new ArrayList<Branch>();

  int generation;
  float speed;
  float theta;

  Branch(Vec2D p, Vec2D d, float s, float t, int g) {
    currPos = p;
    dir = d;
    speed = s;
    theta = t;
    generation = g;
    path.add(p.copy());
  }

  void grow() {
    if (path.size() < MAX_LEN) {
      if (doWrap) {
        Vec2D newPos = currPos.add(dir.scale(speed));
        if (newPos.x < 0 || newPos.x > width) dir.x *= -1;
        if (newPos.y < 0 || newPos.y > height) dir.y *= -1;
      }
      currPos.addSelf(dir.scale(speed));
      dir.rotate(random(-0.5, 0.5) * THETA);
      path.add(currPos.copy());
      if (generation < MAX_GEN && random(1) < BRANCH_CHANCE) {
        Vec2D branchDir = dir.getRotated(random(-0.5, 0.5) * BRANCH_THETA);
        Branch b = new Branch(currPos.copy(), branchDir, speed * 0.99, theta, generation + 1);
        children.add(b);
      }
    }
    for (Branch c : children) {
      c.grow();
    }
  }

  void draw() {
    gfx.lineStrip2D(path);
    for (Branch c : children) {
      c.draw();
    }
  }
}

