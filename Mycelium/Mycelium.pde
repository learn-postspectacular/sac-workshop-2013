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
// branch chance per time step
float BRANCH_CHANCE = 0.1;

ToxiclibsSupport gfx;
Branch root;

void setup() {
  size(1650, 600);
  gfx = new ToxiclibsSupport(this);
  root = new Branch(new Vec2D(0, height/2), new Vec2D(1, 0), 10, PI/3, 0);
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
      currPos.addSelf(dir.scale(speed));
      dir.rotate(random(-theta/2, theta/2));
      path.add(currPos.copy());
      //speed *= 0.995;
      if (generation < MAX_GEN && random(1) < BRANCH_CHANCE) {
        Branch b = new Branch(currPos.copy(), dir.copy().rotate(random(-theta/2, theta/2)), speed * 0.99, theta, generation+1);
        children.add(b);
      }
    }
    for (Branch c : children) {
      c.grow();
    }
  }

  void draw() {
    stroke(255 - generation * 20);
    gfx.lineStrip2D(path);
    for (Branch c : children) {
      c.draw();
    }
  }
}

