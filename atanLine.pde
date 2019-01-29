float train = 0;
void atanLine() {
  //println(totalAmp);
  train += map(totalAmp, 0, 4000, 0, 5);

  if (beat.isOnset()) {
    train+=random(30, 50);
  }
  blendMode(BLEND);

  if (totalAmp<1000) {
    background(0);
  } else {
    if (random(map(totalAmp, 1000, 4000, 0, 100)) > 30);
    else background(0);
  }
  //  stroke(20, 175, 200, 120);

  translate(width/2, height/2);
  float shake = constrain(map(totalAmp, 0, 4000, -15, 15), 0, 10);
  translate(random(-shake, shake), random(-shake, shake));

  int R = 1;
  float x1, y1, x2, y2;
  R = 150;
  blendMode(ADD);

  for (float i=train; i<train+360; i+=0.8) {
    x1 = R*sin(radians(i))*sin(radians(i%2));
    y1 = R*cos(radians(i/2))*cos(radians(i/3));

    x2 = R*sin(radians(i+1))*map(106, 0, width, -10, 10);
    y2 = R*cos(radians(i+1))*map(821, 0, height, -10, 10);
    //line(x1, y1, x2, y2);
    //

    float x, y;
    x = x2-x1;
    y = y2-y1;
    pushMatrix();
    translate(x1, y1);
    rotate(atan2(y, x));
    //fill(#72F062, map(223, 0, width, 0, 75));
    //noFill();
    stroke(#41D4F0, map(221, 0, height, 0, 120));
    rect(-100, 0, 450, 5);
    popMatrix();
  }

  for (float i=train; i<train+90; i+=0.5) {
    x1 = R*sin(radians(i))*sin(radians(i*2));
    y1 = R*cos(radians(i))*cos(radians(i/5));

    x2 = R*sin(radians(i*2))*map(189, 0, width, -10, 10);
    y2 = R*cos(radians(i/2))*map(804, 0, height, -10, 10);
    //line(x1, y1, x2, y2);
    //

    float x, y;
    x = x2-x1;
    y = y2-y1;
    pushMatrix();
    translate(x1, y1);
    rotate(atan2(y, x));
    //fill(#80D0DE, map(197, 0, width, 0, 75));
    noFill();
    //stroke(#BB50F2, map(792, 0, height, 0, 45));
    rect(-100, 0, 450, 5);
    popMatrix();
  }
 
}
