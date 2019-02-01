
ArrayList<Particle> particles;
PVector[] attractors;
int attractorsSize = 2;

void particlesInit(PGraphics P) {
  particles = new ArrayList<Particle>();
  attractors = new PVector[10];
  for (int s=0; s<attractorsSize; s++) {
    attractors[s] = new PVector(width/2, height/2);
  }
  for (int s=0; s<300; s++) {
    particles.add(new Particle(width/2, height/2+random(-200, 200), random(-50, 50)));
  }
  P.beginDraw();
  P.blendMode(ADD);
  P.hint(DISABLE_DEPTH_TEST);
  P.colorMode(HSB, 255);
  P.endDraw();
}
PGraphics drawParticleFollow(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  P.pushMatrix();
  P.stroke(0);
  P.strokeWeight(1);  
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));
  P.camera(camX, camY, camZ+500, 0, 0, 0, 0, 1, 0);


  float movementScale = spectrumScale ;
  for (int i=0; i<attractorsSize; i++) {
    P.stroke(255);
    P.point(attractors[i].x, attractors[i].y);
  }
  /*
  attractors[0].x = fftLin.getAvg(0)*movementScale*10;
   attractors[0].y = fftLin.getAvg(3)*movementScale*2;
   */
  attractors[0].x = mouseX;
  attractors[0].y = mouseY;
  attractors[1].x = -1*fftLin.getAvg(0)*movementScale*10;
  attractors[1].y = -1*fftLin.getAvg(3)*movementScale*2;
  attractors[0].z = fftLin.getAvg(13)*movementScale*2;
  attractors[1].z = -1*fftLin.getAvg(13)*movementScale*2;

  if (attractors[0].x>width/2)attractors[0].x = width/2+random(-30, 30);
  if (attractors[0].y>height/2)attractors[0].y =height/2+random(-30, 30);
  if (attractors[1].x<-width/2)attractors[1].x = -width/2+random(-30, 30);
  if (attractors[1].y<-height/2)attractors[1].y = -height/2+random(-30, 30);
  //  attractors[1].z = 50*sin(radians(frameCount*2));

  for (int s=0; s< particles.size(); s++) {
    for (int i=0; i<attractorsSize; i++) {
      particles.get(s).attracted(attractors[i], i);
    }
    particles.get(s).update();
    particles.get(s).show(P);
  }
  P.popMatrix();
  P.endDraw();
  return P;
}
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
  void show(PGraphics P) {
    P.noFill();
    P.stroke(255, 10);
    P.strokeWeight(1);
    //point(pos.x, pos.y);
    //line(pos.x, pos.y, prevPos.x, prevPos.y);
    //colorMode(HSB, 255);
    //blendMode(ADD);
    int showLength = (int)map(constrain(totalAmp, 0, 1000), 0, 1000, 10, trace.size());
    //println(fftLin.getAvg(0));
    for (int s=traceLength-1; s>traceLength-showLength; s--) {
      if (colorCode<6) {
        P.colorMode(HSB);
        P.stroke( 
          map(s, traceLength-showLength, traceLength, 100, 120), 
          map(s, traceLength-showLength, traceLength, 80, map(fftLin.getAvg(10)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 50, 140), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      } else {
        P.stroke( 
          map(s, traceLength-showLength, traceLength, 200, 255), 
          map(s, traceLength-showLength, traceLength, 0, map(fftLin.getAvg(13)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 50, 120), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      }
      P.line(trace.get(s-1).x, trace.get(s-1).y, trace.get(s-1).z, trace.get(s).x, trace.get(s).y, trace.get(s).z);
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
