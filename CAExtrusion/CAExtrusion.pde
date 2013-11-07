import toxi.geom.*;
import toxi.sim.automata.*;
import toxi.util.*;
import toxi.processing.*;
import java.util.*;

// Matrix dimensions
int COLS = 50;
int ROWS = 50;

byte[] BIRTH_RULES = new byte[] { 
  1
};
//byte[] SURVIVAL_RULES = new byte[] { 1, 4, 5, 7 };
byte[] SURVIVAL_RULES = new byte[] { 
  0, 1, 2, 3, 4, 5, 6, 7, 8
};

CAMatrix ca;
List<int[]> history = new ArrayList<int[]>(); 
ToxiclibsSupport gfx;

boolean doSave = false;
String sessionID = DateUtils.timeStamp();

void setup() {
  size(600, 600, P3D);
  gfx = new ToxiclibsSupport(this);
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
  lights();
  //float scale = (float)width / COLS;
  //float r = 10 / scale;
  //scale(scale);
  //translate(0.5, 0.5);  
  int[] cells = ca.getMatrix();
  int[] backup = new int[cells.length];
  // http://is.gd/5C0zej
  System.arraycopy(cells, 0, backup, 0, cells.length);
  history.add(backup);
  // draw cells in white
  fill(255);
  translate(width/2, height/2, 0);
  rotateX(PI/3);  // 60 deg
  rotateZ(PI/6);  // 30 deg
  scale(4);
  // outermost loop iterates over all history slices
  for (int z = 0; z < history.size(); z++) {
    int[] slice = history.get(z);    // history[z]
    // process all cells for current slice
    for (int y = 0; y < ROWS; y++) {
      for (int x = 0; x < COLS; x++) {
        int idx = x + y * COLS;
        int cellV = slice[idx];
        // ignore dead cells
        if (cellV > 0) {
          AABB box = new AABB(new Vec3D(x,y,z), 0.5);
          gfx.box(box);
        }
      }
    }
  }

  //drawGeneration2D(cells, r);
  popMatrix();
  // draw rule information in top/left corner
  fill(0);
  text("birth: "+drawRuleInfo(BIRTH_RULES), 20, 20);
  text("survive: "+drawRuleInfo(SURVIVAL_RULES), 20, 40);
  if (doSave) {
    saveFrame(sessionID+"/####.png");
  }
}

String drawRuleInfo(byte[] rule) {
  String txt = "";
  for (byte r : rule) {
    txt += r + ",";
  }
  return txt;
}

void drawGeneration2D(int[] cells, float r) {
  for (int y = 0; y < ROWS; y++) {
    for (int x = 0; x < COLS; x++) {
      int idx = x + y * COLS;
      int cellV = cells[idx];
      if (cellV > 0) {
        ellipse(x, y, r, r);
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    doSave = !doSave;
    if (doSave) {
      println("started recording");
    } 
    else {
      println("stopped recording");
    }
  }
}

