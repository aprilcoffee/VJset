
PGraphics drawSoundwaveSphere(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  P.hint(DISABLE_DEPTH_TEST);
  P.colorMode(HSB, 255);
  P.blendMode(ADD);
  //for (int s=0; s<in.bufferSize()-1; s++) {
  //  stroke(255, in.mix.get(s)*5000);
  //  line(s, height/2+in.mix.get(s)*500, s, height/2-in.mix.get(s)*500);
  //}
  //detectBeat();
  // println(frameCount);


  //camX = camDis*sin(radians(tempCamA))*cos(radians(tempCamT));
  //camY = camDis*sin(radians(tempCamT));
  //camZ = camDis*cos(radians(tempCamA))*cos(radians(tempCamT));

  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camA))*sin(radians(camT));
  camZ = camDis*cos(radians(camA));
  P.camera(camX, camY, camZ+500, 0, 0, 0, 0, 1, 0);

  //translate(random(-15, 15), random(-15, 15)-100);

  int totalSize = 80;
  PVector[][] pp = new PVector[totalSize][totalSize];
  for (int i = 0; i<totalSize; i++) {
    float lat = map(i, 0, totalSize-1, -HALF_PI, HALF_PI);
    for (int j=0; j<totalSize; j++) {
      float lon = map(j, 0, totalSize-1, -PI, PI);

      int imnd = i+j*total;
      //float r = 300 + in.mix.get(imnd%1024)*audioAmpScale;
      float r = 300 + in.mix.get(imnd%1024)*audioAmpScale/2;

      float x = r*cos(lat)*cos(lon);
      float y = r*sin(lat)*cos(lon);
      float z = r*sin(lon);
      pp[i][j] = new PVector(x, y, z);
    }
  }
  
  P.rotateZ(360*sin(radians(frameCount*0.39)));
  P.rotateY(360*sin(radians(frameCount*1.73)));
  P.rotateX(360*sin(radians(frameCount*1.2)));
  
  for (int i=0; i<totalSize-1; i++) {
    //stroke(255, in.mix.get(i)*audioAmpScale/2);
    P.beginShape(TRIANGLE_STRIP);
    P.stroke(f_High*255, f_total*255*norm(midi.control[3][0], 0, 127), f_total*200, 50);
    P.noFill();  
    for (int j=0; j<totalSize-1; j++) {
      P.vertex(pp[i][j].x, pp[i][j].y, pp[i][j].z);
      P.vertex(pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    P.endShape();
  }

  P.blendMode(BLEND);
  P.noStroke();
  P.fill(0, 255*norm(midi.control[3][1], 0, 127));
  //P.translate(random( -f_total*100), random(f_total*100));
  P.sphere(150 + 50*sin(radians(frameCount*1.3)));
  P.endDraw();
  return P;
}
