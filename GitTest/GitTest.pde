import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

ToxiclibsSupport gfx;

void setup() {
  size(400, 400, P3D);
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  background(255);

  translate(width/2, height/2, 0);
  
  float shapeH = mouseY - 50;
  // static anchor points
  Vec2D pa = new Vec2D(-150, -shapeH/2);
  Vec2D pb = new Vec2D(150, pa.y);
  Vec2D pc = new Vec2D(mouseX-150, -pb.y);
  Vec2D pd = new Vec2D(-pc.x, pc.y);
  Line2D a = new Line2D(pa, pc);
  Line2D b = new Line2D(pb, pd);
  gfx.line(a);
  gfx.line(b);
  Line2D.LineIntersection isec = a.intersectLine(b);
  boolean isIntersect = (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING); 
  if (isIntersect) {
    Vec2D i = isec.getPos();
    //gfx.circle(i, 10);
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
    Vec2D m4 = new Vec2D(-m2.x, m2.y);
    gfx.line(new Line2D(pd, m4));
    gfx.line(new Line2D(m4, pa));
    
    LineStrip2D strip = new LineStrip2D();
    strip.add(pa);
    strip.add(m1);
    strip.add(pb);
    strip.add(m2);
    strip.add(pc);
    strip.add(m3);
    strip.add(pd);
    strip.add(m4);
    strip.add(pa);
    
    List<Vec2D> points = strip.getDecimatedVertices(30);
    
    Polygon2D poly = new Polygon2D(points);
    //Vec2D c = poly.getCentroid().invert();
    //translate(c.x, c.y, 0);
    
    fill(255,0,255, 128);
    gfx.polygon2D(poly);
  }
}


