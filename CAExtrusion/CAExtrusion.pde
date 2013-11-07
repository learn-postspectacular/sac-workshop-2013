import toxi.geom.*;
import toxi.sim.automata.*;

// Matrix dimensions
int COLS = 50;
int ROWS = 50;

byte[] BIRTH_RULES = new byte[] { 1 };
//byte[] SURVIVAL_RULES = new byte[] { 1, 4, 5, 7 };
byte[] SURVIVAL_RULES = new byte[] { 
  0, 1, 2, 3, 4, 5, 6, 7, 8
};

CAMatrix ca;
boolean doSave = true;

void setup() {
  size(600, 600, P3D);
  //frameRate(1);
  ca = new CAMatrix(COLS, ROWS);
  // last 2 parameters of CARule:
  // 2 = max. cell age, false = no wrap around 
  CARule r = new CARule2D(BIRTH_RULES, SURVIVAL_RULES, 200, false);
  ca.setRule(r);
  // see matrix with single cell organism
  ca.setStateAt(COLS/2, ROWS/2, 1);
}

void draw() {
  ca.update();
  background(128); // 128 = 50% of 256
  noStroke();
  pushMatrix();
  float scale = (float)width / COLS;
  float r = 10 / scale;
  scale(scale);
  translate(0.5, 0.5);  
  int[] cells = ca.getMatrix();
  for (int y = 0; y < ROWS; y++) {
    for (int x = 0; x < COLS; x++) {
      int idx = x + y * COLS;
      int cellV = cells[idx];
      if (cellV > 0) {
        ellipse(x, y, r, r);
      }
    }
  }
  popMatrix();
  if (doSave) {
    saveFrame("ca-####.png");
  }
}

void keyPressed() {
  if (key == ' ') {
    doSave = !doSave;
    if (doSave) {
      println("started recording");
    } else {
      println("stopped recording");
    }
  }
}
