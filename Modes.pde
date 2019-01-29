void spaceMode() {
  background(0);

  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  pushMatrix();
  tint(100);
  imageMode(CENTER);
  image(spaceBG, width/2, height/2, width, height);
  popMatrix();

  for (int s=0; s<5; s++) {
    stars.add(new Star(10, 100));
  }
  starField.beginDraw();
  //if (random(5)>3) 
  starField.background(0, 0);
  starField.translate(starWidth/2, starHeight/2);
  for (int s=0; s<stars.size(); s++) {
    stars.get(s).update();
    if (stars.get(s).pos.z < 1) {
      stars.remove(s);
      continue;
    }
    stars.get(s).show(starField);
  }
  starField.endDraw();
  imageMode(CENTER);
  translate(width/2, height/2);

  hint(DISABLE_DEPTH_TEST);

  //rotate(radians(frameCount));
  tint(255);
  image(starField, 0, 0, width, height);

  pushMatrix();
  pushStyle();
  float camA = handRight.x;
  float camT = handRight.y;
  float camDis = handRight.z;
  // println(frameCount);

  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  // camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  camera(0, -150, 2000, 0, 0, 0, 0, 1, 0);


  pushMatrix();
  soundwaveSphere();
  popMatrix();

  blendMode(ADD);
  drawTerrain();   

  blendMode(BLEND);
  lights();
  PVector temp = new PVector();
  temp.x = handRight.x*10;
  temp.y = handRight.y*10-50+50*sin(radians(frameCount));
  temp.z = handRight.z/100;


  spaceshipPos.add((PVector.sub(temp, spaceshipPos)).mult(0.1));

  translate(spaceshipPos.x, spaceshipPos.y, spaceshipPos.z);
  scale(50);
  shape(spaceShip);
  popMatrix();
  popStyle();
}

void soundwaveSphere() {

  //for (int s=0; s<in.bufferSize()-1; s++) {
  //  stroke(255, in.mix.get(s)*5000);
  //  line(s, height/2+in.mix.get(s)*500, s, height/2-in.mix.get(s)*500);
  //}
  //detectBeat();


  float camA = handRight.x;
  float camT = handRight.y;
  float camDis = handRight.z;
  // println(frameCount);

  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  camera(camX, camY, camZ+500, 0, 0, 0, 0, 1, 0);

  translate(0, -500);
  //translate(random(-15, 15), random(-15, 15)-100);

  int total = 100;
  PVector[][] pp = new PVector[total][total];
  for (int i = 0; i<total; i++) {
    float lat = map(i, 0, total-1, 0, PI);
    for (int j=0; j<total; j++) {
      float lon = map(j, 0, total-1, -PI, PI);

      int imnd = i+j*total;
      float r = 200 + in.mix.get(imnd%1024)*audioAmpScale*3;

      float x = r*cos(lat)*cos(lon);
      float y = r*sin(lat)*cos(lon);
      float z = r*sin(lon);

      pp[i][j] = new PVector(x, y, z);
    }
  }

  for (int i=0; i<total-1; i++) {
    beginShape(TRIANGLE_STRIP);
    //stroke(255, in.mix.get(i)*audioAmpScale/2);
    colorMode(HSB, 255);
    stroke(map(totalAmp ,0, 4000, 0, 255), totalAmp/20, totalAmp/20,30);

    noFill();  
    for (int j=0; j<total-1; j++) {
      vertex(pp[i][j].x, pp[i][j].y, pp[i][j].z);
      vertex(pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    endShape();
  }
}
