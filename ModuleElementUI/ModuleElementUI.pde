/**
 * Constructing a simple polygon module with just line operations.
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */
import toxi.geom.*;
import toxi.processing.*;
import controlP5.*;

import java.util.*;

ToxiclibsSupport gfx;
ControlP5 ui;

float linePosX, linePosY;
float offsetC, offsetD;

void setup() {
  size(400, 400, P3D);
  gfx = new ToxiclibsSupport(this);
  ui = new ControlP5(this);
  ui.addSlider("linePosX").setPosition(20, 20)
    .setRange(150, 300);
  ui.addSlider("linePosY").setPosition(20, 40)
    .setRange(0, 300);
  ui.addSlider("offsetC").setPosition(20, 60)
    .setRange(-0.5, 0.5);
  ui.addSlider("offsetD").setPosition(20, 80)
    .setRange(-0.5, 0.5);
}

void draw() {
  background(255);

  pushMatrix();
  translate(width/2, height/2, 0);
  if (keyPressed && key == ' ') {
    rotateX(mouseY*0.01);
    rotateY(mouseX*0.01);
  }

  float shapeH = linePosY - 50;
  // static anchor points
  Vec2D pa = new Vec2D(-150, -shapeH/2);
  Vec2D pb = new Vec2D(150, pa.y);
  Vec2D pc = new Vec2D(linePosX-150, -pb.y + offsetC * shapeH );
  Vec2D pd = new Vec2D(-pc.x, -pb.y + offsetD * shapeH);
  Line2D a = new Line2D(pa, pc);
  Line2D b = new Line2D(pb, pd);
  gfx.line(a);
  gfx.line(b);
  Line2D.LineIntersection isec = a.intersectLine(b);
  boolean isIntersect = (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING); 
  if (isIntersect) {
    Vec2D i = isec.getPos();
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

    fill(255, 0, 255, 128);
    Polygon2D poly = new Polygon2D(pa, m1, pb, m2, pc, m3, pd, m4);
    gfx.polygon2D(poly);
  }
  popMatrix();
}

