/**
 * Nested coordinate systems via pushMatrix/popMatrix
 *
 * This file is part of the SAC 2013 workshop project
 * (c) 2013 Karsten Schmidt
 * LGPLv3 licensed 
 */
size(500,500);
pushMatrix();

translate(100,100);
rect(0,0, 100, 100);

pushMatrix();
translate(200,0);
rect(0,0, 100, 100);

pushMatrix();
rotate(-PI/4);
rect(0,0, 100, 100);

popMatrix();
popMatrix();
translate(0, 200);
rect(0,0, 100, 100);

popMatrix();

