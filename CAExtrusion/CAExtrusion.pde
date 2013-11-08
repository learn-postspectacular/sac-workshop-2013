import toxi.geom.*;
import toxi.sim.automata.*;
import toxi.util.*;
import toxi.processing.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import java.util.*;

// Matrix dimensions
int COLS = 50;
int ROWS = 50;
int MAX_HISTORY = 20;

Vec3D SCALE = new Vec3D(COLS, ROWS, MAX_HISTORY).scale(2);

byte[] BIRTH_RULES = new byte[] { 
  0
};
//byte[] SURVIVAL_RULES = new byte[] { 1, 4, 5, 7 };
byte[] SURVIVAL_RULES = new byte[] { 
  2,7,8
};

CAMatrix ca;
List<int[]> history = new ArrayList<int[]>(); 
VolumetricSpace voxels;
ToxiclibsSupport gfx;

boolean doSave = true;
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
  // create container for voxel data
  voxels=new VolumetricSpaceArray(SCALE, COLS, ROWS, MAX_HISTORY);
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
  if (history.size() > MAX_HISTORY) {
    history.remove(0);
  }
  // draw cells in white
  fill(255);
  translate(width/2, height/2, 0);
  rotateX(PI/3);  // 60 deg
  rotateZ(PI/6);  // 30 deg
  TriangleMesh mesh = new TriangleMesh();
  // outermost loop iterates over all history slices
  for (int z = 0; z < history.size(); z++) {
    int[] slice = history.get(z);    // history[z]
    // process all cells for current slice
    for (int y = 0; y < ROWS; y++) {
      for (int x = 0; x < COLS; x+=2) {
        int idx = x + y * COLS;
        int cellV = slice[idx];        
        voxels.setVoxelAt(x,y,z, min(cellV, 1));
      }
    }
  }
  voxels.closeSides();
  IsoSurface surface=new ArrayIsoSurface(voxels);
  surface.computeSurfaceMesh(mesh,0.5);
  //mesh.flipVertexOrder();
  gfx.mesh(mesh);
  //drawGeneration2D(cells, r);
  // revert back to 2D
  popMatrix();
  // draw rule information in top/left corner
  fill(0);
  text("birth: "+drawRuleInfo(BIRTH_RULES), 20, 20);
  text("survive: "+drawRuleInfo(SURVIVAL_RULES), 20, 40);
  if (doSave) {
    saveFrame(sessionID+"/####.png");
    mesh.saveAsOBJ(sketchPath(sessionID+"/"+nf(frameCount,4)+".obj"));
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

