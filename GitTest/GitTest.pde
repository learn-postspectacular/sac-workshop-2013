import toxi.geom.*;
import toxi.processing.*;

ToxiclibsSupport gfx;

void setup() {
  size(400,400);
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  background(255);

  // static anchor points
  Vec2D pa = new Vec2D(50,50);
  Vec2D pb = new Vec2D(width - 50,50);
  
  Line2D a = new Line2D(pa, new Vec2D(mouseX, mouseY));
  Line2D b = new Line2D(pb, new Vec2D(width - mouseX, mouseY));
  gfx.line(a);
  gfx.line(b);
  Line2D.LineIntersection isec = a.intersectLine(b);
  boolean isIntersect = (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING); 
  if (isIntersect) {
    Vec2D i = isec.getPos();
    gfx.circle(i, 10);
    
    Line2D t = new Line2D(pa, pb);
    Vec2D pi = t.closestPointTo(i);
    Vec2D m1 = new Line2D(i, pi).getMidPoint();
    gfx.line(new Line2D(pa, m1));
    gfx.line(new Line2D(m1, pb));
    
  }
  
}



