ArrayList<Text> texts = new ArrayList<Text>();
void runText() {




  float camA = handRight.x;
  float camT = handRight.y;
  float camDis = handRight.z;
  // println(frameCount);

  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  if (totalAmp<1000) {
    background(0);
  } else {
    if (random(map(totalAmp, 1000, 4000, 0, 100)) > 30);
    else background(0);
  }

  float addTextNum = constrain(map(totalAmp, 0, 4000, -10, 20), 0, 20);

  boolean isBeat = false;

  if (beat.isOnset()) {
    println("Beat");
    isBeat = true;
  }
  for (int i = 0; i < addTextNum; i++) {
    texts.add(new Text());
  }

  for (int s=0; s<texts.size(); s++) {
    texts.get(s).update(isBeat);
    texts.get(s).show();
    if (texts.get(s).pos.y < -500)texts.remove(s);
  }
}
class Text {
  PVector pos;
  PVector ppos;
  PVector v;
  float textsize;
  char text;
  Text() {
    pos = new PVector(random(-width/2, width/2), height*1.5, random(-500, 500));
    ppos = pos.copy();
    text = char(int(random(0, 128)));
    v = new PVector(0, random(-5, -10), 0);
  }
  Text(PVector _pos) {
    pos = _pos.copy();
    ppos = pos.copy();
    text = char(int(random(0, 128)));
    v = new PVector(0, random(-5, -10), 0);
  }
  void update(boolean _isBeat) {
    if (_isBeat) {
      ppos = new PVector(random(-width/2, width/2), pos.y, random(-500, 500));
    }
    ppos.add(v);

    pos.add((PVector.sub(ppos, pos)).mult(0.1));
  }
  void update() {

    ppos.add(v);

    pos.add((PVector.sub(ppos, pos)).mult(0.1));
  }
  void show() {
    pushMatrix();
    fill(255);
    translate(pos.x, pos.y, pos.z);
    text(text, 0, 0);
    popMatrix();
  }
}
