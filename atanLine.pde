
float train = 0;
PGraphics drawatanWave(PGraphics P) {

  P.beginDraw();

  //println(totalAmp);
  train += map(f_total, 0, 1, 3, 10);

  if (beat.isOnset()) {
    train+=random(30, 50);
  }
  P.blendMode(BLEND);

  if (f_total<0.3) {
    P.background(0, 0);
  } else {
    if (random(map(f_total, 0.3, 1, 0, 100)) > 30);
    else P.background(0, 0);
  }
  P.colorMode(HSB, 255);
  //  stroke(20, 175, 200, 120);

  P.translate(P.width/2, P.height/2);
  float shake = constrain(map(totalAmp, 0, 4000, -15, 15), 0, 10);
  P.translate(random(-shake, shake), random(-shake, shake));

  int R = 1;
  float x1, y1, x2, y2;
  R = 150;
  P.blendMode(ADD);


  P.pushMatrix();
  P.translate(-midi.control[2][0]*5*(0.8 + f_total/2), 0);
  for (float i=train; i<train+150; i+=0.8) {
    x1 = R*sin(radians(i))*sin(radians(i/0.378));
    y1 = R*cos(radians(i/2))*cos(radians(i/3));

    x2 = R*sin(radians(i+1))*map(106, 0, P.width, -10, 10);
    y2 = R*cos(radians(i+1))*map(821, 0, P.height, -10, 10);
    //line(x1, y1, x2, y2);

    float x, y;
    x = x2-x1;
    y = y2-y1;
    P.pushMatrix();
    P.translate(x1, y1);
    P.rotate(atan2(y, x));
    P.stroke(f_Mid*255, 200*norm(midi.control[2][1], 0, 127), 25 + f_total*225, map(221, 0, P.height, 0, 120));
    P.rect(-100, 0, 450, 5);
    P.popMatrix();
  }

  P.popMatrix();



  for (float i=train; i<train+90; i+=0.5) {
    x1 = R*sin(radians(i))*sin(radians(i*2));
    y1 = R*cos(radians(i))*cos(radians(i/5));

    x2 = R*sin(radians(i*2))*map(189, 0, P.width, -10, 10);
    y2 = R*cos(radians(i/2))*map(804, 0, P.height, -10, 10);
    //line(x1, y1, x2, y2);
    //
    float x, y;
    x = x2-x1;
    y = y2-y1;
    P.pushMatrix();
    P.translate(x1, y1);
    P.rotate(atan2(y, x));
    //fill(#80D0DE, map(197, 0, width, 0, 75));
    P.noFill();
    stroke(f_Low*255, 200*norm(midi.control[2][1], 0, 127), 25 + f_total*225, map(792, 0, height, 0, 45));
    P.rect(-100, 0, 450, 5);
    P.popMatrix();
  }

  P.pushMatrix();
  P.translate(midi.control[2][0]*5 * (0.8 + f_total/2), 0);
  for (float i=train; i<train+180; i+=0.8) {
    x1 = R*sin(radians(i/0.796))*sin(radians(i%2));
    y1 = R*tan(radians(i*1.32))*cos(radians(i/2))*cos(radians(i/3));

    x2 = R*sin(radians(i+1))*map(500, 0, P.width, -10, 10);
    y2 = R*cos(radians(i+1))*map(300, 0, P.height, -10, 10);
    //line(x1, y1, x2, y2);
    //

    float x, y;
    x = x2-x1;
    y = y2-y1;
    P.pushMatrix();
    P.translate(x1, y1);
    P.rotate(atan2(y, x));
    P.stroke(f_High*255, 200*norm(midi.control[2][1], 0, 127), 25+f_total*225, map(221, 0, P.height, 0, 120));
    P.rect(-100, 0, 450, 5);
    P.popMatrix();
  }
  P.popMatrix();


  P.endDraw();
  return P;
}
