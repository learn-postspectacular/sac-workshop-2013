import toxi.geom.*;
import toxi.processing.*;

ToxiclibsSupport gfx;

void setup() {
  size(400,400);
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  background(255);
  //line(x1, y1, x2, y2); // p5 way
  Line2D a = new Line2D(new Vec2D(50,50), new Vec2D(mouseX, mouseY));
  Line2D b = new Line2D(new Vec2D(width - 50,50), new Vec2D(width - mouseX, mouseY));
  gfx.line(a);
  gfx.line(b);
  Line2D.LineIntersection isec = a.intersectLine(b);
  boolean isIntersect = (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING); 
  if (isIntersect) {
    gfx.circle(isec.getPos(), 10);
  }
}



