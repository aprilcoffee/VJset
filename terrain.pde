void terrainInit(){
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
void drawTerrain() {
  pushMatrix();
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
      terrainLeft[x][0] = fftLin.getBand(x*2)/2*40+in.left.get(x*2)*40;
      terrainRight[x][0]= fftLin.getBand(x*2)/2*40+in.right.get(x*2)*40;
    } else {
      terrainLeft[x][0] = -fftLin.getBand(x*2)/2*40+in.left.get(x*2)*40;
      terrainRight[x][0]= -fftLin.getBand(x*2)/2*40+in.right.get(x*2)*40;
    }
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  translate(0, 0);
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
  pushMatrix();
  //noFill();
  //fill(255,0,0);
  translate(-500, 0);
  rotateX(PI/2);
  scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    switch (TerrainMode) {
    case 0:
      {
        beginShape(POINT);
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          stroke(map(audioAmp[y], 0, 50000, 0, 255), map(audioAmp[y], 0, 100000, 0, 255), audioAmp[y], map(y, rows, 0, 0, 150));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          point(x*scl, y*scl, terrainLeft[x][y]);
          point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          //vertex(x*scl, y*scl, terrainLeft[x][y]);
          //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        endShape();
        break;
      }
    case 1:
      {
        beginShape();
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          noFill();
          stroke(map(audioAmp[y]%10000, 0, 10000, 0, 255), map(y, rows, 0, 0, 100));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(x*scl, y*scl, terrainLeft[x][y]);
          vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        endShape();
        break;
      }
    case 2:
      {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=3) {
          //noStroke();
          //fill(255,0,0);
          noStroke();
          fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(x*scl, y*scl, terrainLeft[x][y]);
          vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        endShape();
        break;
      }
    case 3:
      {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=5) {
          stroke(255, map(y, rows, 0, 10, 80));
          //fill(255,0,0);

          fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(x*scl, y*scl, terrainLeft[x][y]);
          vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        endShape();
        break;
      }
    }
  }
  popMatrix();

  //-------------------terrain2-------------------

  pushMatrix();
  translate(500, 0);
  rotateX(PI/2);
  scale(2, 1);

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    switch(TerrainMode) {
    case 0:
      {
        beginShape(POINT);
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          stroke(map(audioAmp[y], 0, 30000, 0, 255), map(audioAmp[y], 0, 100000, 0, 255), audioAmp[y], map(y, rows, 0, 0, 100));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          point(-x*scl, y*scl, terrainRight[x][y]);
          point(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
          //vertex(x*scl, y*scl, terrainLeft[x][y]);
          //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        }
        endShape();
        break;
      }
    case 1:
      {
        beginShape();
        for (int x = 0; x < cols; x++) {
          //noStroke();
          //fill(255,0,0);
          noFill();
          stroke(map(audioAmp[y], 0, 5000, 0, 255), map(y, rows, 0, 0, 200));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(-x*scl, y*scl, terrainRight[x][y]);
          vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        endShape();
        break;
      }
    case 2:
      {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=3) {
          //noStroke();
          //fill(255,0,0);
          noStroke();
          // println(fftLin.getBand(x*2));
          fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(-x*scl, y*scl, terrainRight[x][y]);
          vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        endShape();
        break;
      }
    case 3:
      {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x+=5) {
          stroke(255, map(y, rows, 0, 10, 80));
          //fill(255,0,0);
          fill(map(audioAmp[y]%10000, 0, 10000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 0, 50));
          //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
          //fill(255);
          //point(x*scl, y*scl, terrainLeft[x][y]);
          //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
          vertex(-x*scl, y*scl, terrainRight[x][y]);
          vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
        }
        endShape();
        break;
      }
    }
  }
  popMatrix();
  popMatrix();
}
