PVector spaceshipPos;
PShape spaceShip;

PGraphics drawSpaceShip(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  P.blendMode(BLEND);
  P.lights();
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  P.camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  PVector temp = new PVector();
  temp.x = handRight.x*10;
  temp.y = handRight.y*10-50+50*sin(radians(frameCount));
  temp.z = handRight.z/100;

  spaceshipPos.add((PVector.sub(temp, spaceshipPos)).mult(0.1));

  P.translate(spaceshipPos.x, spaceshipPos.y, abs(spaceshipPos.z));
  P.rotateY(-HALF_PI);
  P.scale(10);
  P.shape(spaceShip);
  P.endDraw();
  return P;
}
