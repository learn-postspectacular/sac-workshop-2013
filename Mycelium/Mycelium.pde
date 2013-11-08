import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

ToxiclibsSupport gfx;
Branch root;

void setup() {
  size(1650, 600);
  gfx = new ToxiclibsSupport(this);
  root = new Branch(new Vec2D(0, height/2), new Vec2D(1, 0), 10, PI/6, 0);
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
  }

  void grow() {
    if (path.size() < 100) {
      path.add(currPos.copy());
      currPos.addSelf(dir.scale(speed));
      dir.rotate(random(-theta/2, theta/2));
      //speed *= 0.995;
      if (generation < 3 && random(100) < 3) {
        Branch b = new Branch(currPos.copy(), dir.copy().rotate(random(-theta/2, theta/2)), speed * 0.99, theta, generation+1);
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

