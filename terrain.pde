//Terrain
float[][] terrainLeft;
float[][] terrainRight;
float[] audioAmp;
int cols, rows;
int scl = 20;
int w = 1000;
int h = 2000;

boolean TerrainRandom = false;
boolean terrainRandomTrigger = false;
int TerrainMode = 2;
void terrainInit() {
  cols = w/scl;
  rows = h/scl;
  terrainLeft = new float[cols][rows];
  terrainRight = new float[cols][rows];
  audioAmp = new float[rows];
  for (int y = 0; y < rows; y++) { 
    for (int x = 0; x < cols; x++) {
      terrainLeft[x][y] = 0;
      terrainRight[x][y] = 0;
    }
    audioAmp[y] = 0;
  }
}
PGraphics drawTerrain(PGraphics P) {

  P.beginDraw();
  P.background(0,0);
  P.colorMode(HSB);
  P.hint(DISABLE_DEPTH_TEST);
  P.camera(0, -150, 2000, 0, 0, 0, 0, 1, 0);

  for (int y = rows-1; y >= 1; y--) {
    for (int x = 0; x < cols; x++) {  
      terrainLeft[x][y] = terrainLeft[x][y-1];
      terrainRight[x][y] = terrainRight[x][y-1]; 
      audioAmp[y]=audioAmp[y-1];
    }
  }
  audioAmp[0] = 0;
  for (int x = 0; x < cols; x++) {
    if (x%2==0) {
      terrainLeft[x][0] = fftLin.getBand(x*2)/2*40+in.left.get(x*2)*20;
      terrainRight[x][0]= fftLin.getBand(x*2)/2*40+in.right.get(x*2)*20;
    } else {
      terrainLeft[x][0] = -fftLin.getBand(x*2)/2*40+in.left.get(x*2)*20;
      terrainRight[x][0]= -fftLin.getBand(x*2)/2*40+in.right.get(x*2)*20;
    }
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  P.translate(0, 0);
  //println(audioAmp[0]);
  //background(255); 
  //blendMode(ADD);
  //println(fft.specSize());

  if (TerrainRandom==true) {
    if (terrainRandomTrigger==true) {
      TerrainMode = (int)random(4);
      terrainRandomTrigger=false;
    }
  } 

  //-------------------terrain1-------------------
  P.pushMatrix();
  //noFill();
  //fill(255,0,0);
  P.translate(-500, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    switch (TerrainMode) {
    case 0:
      {
        P.beginShape(POINT);
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          P.stroke(map(audioAmp[y], 0, 50000, 0, 255), map(audioAmp[y], 0, 100000, 0, 255), audioAmp[y], map(y, rows, 0, 0, 150));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          P.point(x*scl, y*scl, terrainLeft[x][y]);
          P.point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          //vertex(x*scl, y*scl, terrainLeft[x][y]);
          //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 1:
      {
        P.beginShape();
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          P.noFill();
          P.stroke(map(audioAmp[y]%10000, 0, 10000, 0, 255), map(y, rows, 0, 0, 100));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(x*scl, y*scl, terrainLeft[x][y]);
          P.vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 2:
      {
        P.beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=3) {
          //noStroke();
          //fill(255,0,0);
          P.noStroke();
          P.fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(x*scl, y*scl, terrainLeft[x][y]);
          P.vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 3:
      {
        P.beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=5) {
          P.stroke(255, map(y, rows, 0, 10, 80));
          //fill(255,0,0);

          P.fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(x*scl, y*scl, terrainLeft[x][y]);
          P.vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        P.endShape();
        break;
      }
    }
  }
  P.popMatrix();

  //-------------------terrain2-------------------

  P.pushMatrix();
  P.translate(500, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    switch(TerrainMode) {
    case 0:
      {
        P.beginShape(POINT);
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          P.stroke(map(audioAmp[y], 0, 30000, 0, 255), map(audioAmp[y], 0, 100000, 0, 255), audioAmp[y], map(y, rows, 0, 0, 100));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          P.point(-x*scl, y*scl, terrainRight[x][y]);
          P.point(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
          //vertex(x*scl, y*scl, terrainLeft[x][y]);
          //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 1:
      {
        P.beginShape();
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          P.noFill();
          P.stroke(map(audioAmp[y], 0, 5000, 0, 255), map(y, rows, 0, 0, 200));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(-x*scl, y*scl, terrainRight[x][y]);
          P.vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 2:
      {
        P.beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=3) {
          //noStroke();
          //fill(255,0,0);
          P.noStroke();
          // println(fftLin.getBand(x*2));
          P.fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(-x*scl, y*scl, terrainRight[x][y]);
          P.vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        P.endShape();
        break;
      }
    case 3:
      {
        P.beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=5) {
          P.stroke(255, map(y, rows, 0, 10, 80));
          //fill(255,0,0);
          P.fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          P.vertex(-x*scl, y*scl, terrainRight[x][y]);
          P.vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        P.endShape();
        break;
      }
    }
  }
  P.popMatrix();
  P.endDraw();
  return P;

  //for (int s=0; s<tunnel.size(); s++) {
  //  tunnel.get(s).update();
  //  tunnel.get(s).show();
  //  if (tunnel.get(s).z > 1000)tunnel.remove(s);
  //}
}

class Tunnel {
  float x, y, z;
  float len;
  Tunnel() {
    x = 0;
    y = 0;
    z = -2000;
    len = 500;
  }
  void update() {
    z+=30;
  }
  void show() {
    noFill();
    strokeWeight(5);
    stroke(255);
    translate(0, 0, z);
    rect(0, 0, 500, 1000);
  }
}
