/**
 * Demonstration of visualising progression of a 2D cellular automata
 * as extruded 3D voxel mesh, incl. optional mesh smoothing & export
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */

// basic vector math & mesh classes
import toxi.geom.*;
import toxi.geom.mesh.*;
// cellular automata classes
import toxi.sim.automata.*;
// drawing functions
import toxi.processing.*;
// voxel functionality
import toxi.volume.*;
// this package contains the DateUtils class
import toxi.util.*;
// this package is needed for the List & other Java collection types
import java.util.*;

// Matrix dimensions
int COLS = 50;
int ROWS = 50;
// number of recent simulation steps to keep
int MAX_HISTORY = 20;

// final size of voxelized mesh
Vec3D SCALE = new Vec3D(COLS, ROWS, MAX_HISTORY).scale(6);

// Cellular automata rule definitions
// the numbers in this array relate to the numbers of alive neighbor cells
// in the 3x3 neighborhood of each cell
// e.g. the 0 in birth rules means a cell becomes alive when there are NO neighbors
// the survival rules state that a cell remains alives only when it has 2,7 or 8 alive neighbors
byte[] BIRTH_RULES = new byte[] { 
  0
};
byte[] SURVIVAL_RULES = new byte[] { 
  2, 7, 8
};

CAMatrix ca;
List<int[]> history = new ArrayList<int[]>(); 
VolumetricSpace voxels;
ToxiclibsSupport gfx;

// switches for export & mesh smoothing
boolean doSave = false;
boolean doSmooth = false;

// timestamp used as path prefix for exporting frames to a subfolder
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
  int[] cells = ca.getMatrix();
  int[] backup = new int[cells.length];
  // http://is.gd/5C0zej
  System.arraycopy(cells, 0, backup, 0, cells.length);
  history.add(backup);
  // ensure history doesn't grow beyond limit
  if (history.size() > MAX_HISTORY) {
    history.remove(0);
  }
  // draw cells in white
  fill(255);
  // switch to 3D coordinate system
  translate(width/2, height/2, 0);
  rotateX(PI/3);  // 60 deg
  rotateZ(PI/6);  // 30 deg
  // populate voxel array using 3 nested loops over Z, Y & X
  // outermost loop (Z) iterates over all history slices
  for (int z = 0; z < history.size(); z++) {
    int[] slice = history.get(z);    // history[z]
    // process all cells for current slice (XY)
    for (int y = 0; y < ROWS; y++) {
      for (int x = 0; x < COLS; x++) {
        int idx = x + y * COLS;
        int cellV = slice[idx];        
        voxels.setVoxelAt(x, y, z, min(cellV, 1));
      }
    }
  }
  // ensure voxel mesh will be closed on all sides
  voxels.closeSides();

  // create empty Winged-Edge mesh container object
  // as recipient for iso surface
  // unlike the normal TriangleMesh class, the WETriangleMesh
  // stores vertex connectivity, needed for smoothing
  WETriangleMesh mesh = new WETriangleMesh();
  // compute threshold surface of the voxel space
  IsoSurface surface=new ArrayIsoSurface(voxels);
  surface.computeSurfaceMesh(mesh, 0.5);

  // if enabled, apply mesh smoothing
  if (doSmooth) {
    new LaplacianSmooth().filter(mesh, 1);
  }
  // draw mesh
  gfx.mesh(mesh);
  // revert back to 2D
  popMatrix();
  // draw rule information in top/left corner
  fill(0);
  text("birth: "+rulesAsString(BIRTH_RULES), 20, 20);
  text("survive: "+rulesAsString(SURVIVAL_RULES), 20, 40);
  // if enabled, export current mesh & screenshot
  if (doSave) {
    String basePath = sketchPath(sessionID+"/"+nf(frameCount, 4));
    saveFrame(basePath+".png");
    mesh.saveAsOBJ(basePath+".obj");
  }
}

// convert byte array elements into comma separated string
String rulesAsString(byte[] rule) {
  String txt = "";
  for (byte r : rule) {
    txt += r + ",";
  }
  return txt;
}

// key event handling
void keyPressed() {
  // toggle export on/off when SPACE is pressed
  if (key == ' ') {
    doSave = !doSave;
    if (doSave) {
      println("started recording");
    } 
    else {
      println("stopped recording");
    }
  } 
  else if (key == 's') {
    doSmooth = !doSmooth;
  }
}

