import toxi.geom.*;
import toxi.processing.*;

ToxiclibsSupport gfx;

void setup() {
  size(400, 400);
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  background(255);

  // static anchor points
  Vec2D pa = new Vec2D(50, 50);
  Vec2D pb = new Vec2D(width - 50, 50);
  Vec2D pc = new Vec2D(mouseX, mouseY);
  Vec2D pd = new Vec2D(width - mouseX, mouseY);
  Line2D a = new Line2D(pa, pc);
  Line2D b = new Line2D(pb, pd);
  gfx.line(a);
  gfx.line(b);
  Line2D.LineIntersection isec = a.intersectLine(b);
  boolean isIntersect = (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING); 
  if (isIntersect) {
    Vec2D i = isec.getPos();
    gfx.circle(i, 10);
    // top edge
    Line2D t = new Line2D(pa, pb);
    Vec2D pi = t.closestPointTo(i);
    Vec2D m1 = new Line2D(i, pi).getMidPoint();
    gfx.line(new Line2D(pa, m1));
    gfx.line(new Line2D(m1, pb));

    // right edge
    t = new Line2D(pb, pc);
    pi = t.closestPointTo(i);
    Vec2D m2 = new Line2D(i, pi).getMidPoint();
    gfx.line(new Line2D(pb, m2));
    gfx.line(new Line2D(m2, pc));
    
    // bottom edge
    t = new Line2D(pc, pd);
    pi = t.closestPointTo(i);
    Vec2D m3 = new Line2D(i, pi).getMidPoint();
    gfx.line(new Line2D(pc, m3));
    gfx.line(new Line2D(m3, pd));
    
    // left edge
    // m4 = just mirrored version of m2
    Vec2D m4 = new Vec2D(width - m2.x, m2.y);
    gfx.line(new Line2D(pd, m4));
    gfx.line(new Line2D(m4, pa));
  }
}


