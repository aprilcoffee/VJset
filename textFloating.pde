ArrayList<Text> texts = new ArrayList<Text>();
PGraphics drawFloatingText(PGraphics P) {
  P.beginDraw();
  P.blendMode(ADD);
  P.hint(DISABLE_DEPTH_TEST);

  P.background(0, 0);
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camA))*sin(radians(camT));
  camZ = camDis*cos(radians(camA));
  P.camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  boolean isBeat = false;

  if (beat.isOnset()) {
    //println("Beat");
    isBeat = true;
  }
  for (int i = 0; i < f_total*20; i++) {
    texts.add(new Text(P, f_High));
  }

  for (int s=0; s<texts.size(); s++) {
    texts.get(s).update(isBeat, P);
    texts.get(s).show(P);
    if (texts.get(s).pos.y < -500)texts.remove(s);
  }

  P.endDraw();
  return P;
}
class Text {
  PVector pos;
  PVector ppos;
  PVector v;
  float textsize;
  char text;
  float transparent;
  Text(PGraphics P, float _transparent) {
    pos = new PVector(random(-P.width, P.width), P.height*1.5, random(-500, 500));
    ppos = pos.copy();
    text = char(int(random(0, 128)));
    v = new PVector(0, random(-5, -10), 0);
    textsize = random(10, 30);
    transparent = _transparent;
  }
  Text(PVector _pos) {
    pos = _pos.copy();
    ppos = pos.copy();
    text = char(int(random(0, 128)));
    v = new PVector(0, random(-5, -10), 0);
    textsize = random(10, 30);
  }
  void update(boolean _isBeat, PGraphics P) {
    if (_isBeat) {
      ppos = new PVector(random(-P.width, P.width), pos.y, random(-500, 500));
    }
    ppos.add(v);
    pos.add((PVector.sub(ppos, pos)).mult(0.05));
  }
  void update() {
    ppos.add(v);
    pos.add((PVector.sub(ppos, pos)).mult(0.05));
  }
  void show(PGraphics P) {
    P.pushMatrix();
    P.fill(100 + 155* transparent);
    P.textSize(textsize);
    P.translate(pos.x, pos.y, pos.z);
    P.text(text, 0, 0);
    P.noFill();
    P.stroke(255);
    if (midi.control[5][0]>32) {
      if (random(f_High*100)>70) {
        if (random(2)>1)
          P.line(0, 0, 500*f_total*norm(midi.control[5][0], 0, 127), 0);
        else
          P.line(0, 0, -500*f_total*norm(midi.control[5][0], 0, 127), 0);
      }
    }
    P.popMatrix();
  }
}
