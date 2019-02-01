
PGraphics drawSoundwaveSphere(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  P.hint(DISABLE_DEPTH_TEST);
  P.colorMode(HSB,255);
  P.blendMode(ADD);
  //for (int s=0; s<in.bufferSize()-1; s++) {
  //  stroke(255, in.mix.get(s)*5000);
  //  line(s, height/2+in.mix.get(s)*500, s, height/2-in.mix.get(s)*500);
  //}
  //detectBeat();
  // println(frameCount);

  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  P.camera(camX, camY, camZ+500, 0, 0, 0, 0, 1, 0);

  P.translate(0, -200);
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
    P.beginShape(TRIANGLE_STRIP);
    //stroke(255, in.mix.get(i)*audioAmpScale/2);
    P.stroke(map(totalAmp, 0, 4000, 0, 255), totalAmp/20, totalAmp/20, 30);

    P.noFill();  
    for (int j=0; j<total-1; j++) {
      P.vertex(pp[i][j].x, pp[i][j].y, pp[i][j].z);
      P.vertex(pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    P.endShape();
  }
  P.endDraw();
  return P;
}