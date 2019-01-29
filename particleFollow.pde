class Particle {
  PVector pos;
  PVector prevPos;
  ArrayList<PVector> trace;
  int traceLength = 50;
  PVector vel;
  PVector acc;
  float colorCode;
  Particle(float ex, float ey, float ez) {
    pos = new PVector(ex, ey, ez);
    prevPos = pos.copy();
    vel = PVector.random3D();
    vel.setMag(random(3, 5));
    acc = new PVector(0, 0, 0);

    trace = new ArrayList<PVector>();
    for (int s=0; s<traceLength; s++) {
      trace.add(new PVector(pos.x, pos.y, pos.z));
    }
    colorCode = random(10);
  }
  void update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(15);
    acc.mult(0);
  }
  void show() {
    noFill();
    stroke(255, 10);
    strokeWeight(1);
    //point(pos.x, pos.y);
    //line(pos.x, pos.y, prevPos.x, prevPos.y);
    //colorMode(HSB, 255);
    //blendMode(ADD);
    int showLength = (int)map(constrain(totalAmp, 0, 1000), 0, 1000, 10, trace.size());
    //println(fftLin.getAvg(0));
    for (int s=traceLength-1; s>traceLength-showLength; s--) {
      if (colorCode<6) {
        colorMode(HSB);
        stroke( 
          map(s, traceLength-showLength, traceLength, 100, 120), 
          map(s, traceLength-showLength, traceLength, 80, map(fftLin.getAvg(10)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 50, 140), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      } else {
        stroke( 
          map(s, traceLength-showLength, traceLength, 200, 255), 
          map(s, traceLength-showLength, traceLength, 0, map(fftLin.getAvg(13)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 50, 120), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      }
      line(trace.get(s-1).x, trace.get(s-1).y, trace.get(s-1).z, trace.get(s).x, trace.get(s).y, trace.get(s).z);
    }
    trace.remove(0);
    trace.add(new PVector(pos.x, pos.y, pos.z));
  }
  void attracted(PVector target, int flag) {
    PVector force = PVector.sub(target, pos);
    float dsquared = force.magSq();
    dsquared = constrain(dsquared, 50, 400);
    float G = 150;
    float strength = G/dsquared;
    force.setMag(strength);
    acc.add(force);
  }
}
