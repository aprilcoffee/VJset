PVector spaceshipPos;
PShape spaceShip;
ArrayList<Tunnel> tunnel;
boolean isDeadShake = false;

PGraphics drawSpaceShip(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  P.blendMode(BLEND);
  P.hint(DISABLE_DEPTH_TEST);
  //camX = camDis*sin(radians(camA))*cos(radians(camT));
  //camY = camDis*sin(radians(camT));
  //camZ = camDis*cos(radians(camA))*cos(radians(camT));
  //camX = camDis*sin(radians(camA))*cos(radians(camT));
  //camY = camDis*sin(radians(camA))*sin(radians(camT));
  //camZ = camDis*cos(radians(camA));  
  //P.camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  P.camera(0+camAdjustX, -150+camAdjustY, 1600, 0, 0, 0, 0, 1, 0);

  PVector temp = new PVector();
  temp.x = handRight.x*10;
  temp.y = handRight.y*8-50+50*sin(radians(frameCount));
  temp.z = 800+handRight.z/50;

  //-600 700
  //-540 300

  if ( temp.x < -600) temp.x = -600;
  if ( temp.x > 650) temp.x = 650;
  if ( temp.y < -540) temp.y = -540;
  if ( temp.y > 300) temp.y = 300;


  spaceshipPos.add((PVector.sub(temp, spaceshipPos)).mult(0.1));
  //println(spaceshipPos.x, spaceshipPos.y);

  P.rectMode(CENTER);
  P.ellipseMode(CENTER);
  P.colorMode(HSB, 255);
  P.lights();
  P.pushMatrix();
  P.translate(spaceshipPos.x, spaceshipPos.y, abs(spaceshipPos.z));
  P.pushMatrix();
  P.rotateY(-HALF_PI);
  P.scale(20+f_High*2);
  P.shape(spaceShip);
  P.popMatrix();


  P.noFill();
  P.blendMode(ADD);
  P.pushMatrix();
  for (int s=0; s< 1 + midi.control[4][0]/10; s++) {
    P.rotateY(radians(s*13+frameCount));
    P.strokeWeight(0.5);
    P.smooth();
    P.stroke( 255, midi.control[4][0]*2);
    P.noFill();
    P.ellipse(0, 0, 300, 300);

    P.fill(255, 200);
    P.text(s*13+frameCount, 180, s*13);
  }
  P.popMatrix();
  P.popMatrix();

  if (isKick) {

    if (midi.control[4][1]>30) {
      if (midi.control[4][1] > 110) {
        tunnel.add(new Tunnel(random(-400, 500), random(-400, 250), f_total*255, 1));
      } else {
        tunnel.add(new Tunnel(0, 0, f_total*255, 0));
      }
    }
  }
  P.blendMode(ADD);
  for (int s=0; s<tunnel.size(); s++) {
    tunnel.get(s).update();
    tunnel.get(s).show(P);
    if (tunnel.get(s).game==1&&spaceshipPos.z <= tunnel.get(s).z+100 && spaceshipPos.z >= tunnel.get(s).z-100 &&
      spaceshipPos.x <= tunnel.get(s).x+75 && spaceshipPos.x >= tunnel.get(s).x-75 &&
      spaceshipPos.y <= tunnel.get(s).y+75 && spaceshipPos.y >= tunnel.get(s).y-75) {
      tunnel.get(s).isDead = 1;
      isDeadShake = true;
    }
    if (tunnel.get(s).z> 1600 && tunnel.get(s).game==0 )tunnel.remove(s);
    if (tunnel.get(s).z> 900 && tunnel.get(s).game==1 )tunnel.remove(s);
  }
  P.endDraw();



  return P;
}

class Tunnel {
  float x, y, z;
  float len;
  float col;
  float game;
  int isDead;
  Tunnel(float _x, float _y, float _col, int _game) {
    x = _x;
    y = _y;
    col = _col;
    z = -500;
    len = 500;
    game = _game;
    isDead = 0;
  }
  void update() {
    if (isDead >= 1) {
      isDead+=20;
      z+=30;
    } else {
      z+=15;
    }
  }
  void show(PGraphics P) {
    P.noFill();        
    P.pushMatrix();

    if (game==0) {
      P.translate(x, y, z);
      P.strokeWeight(5);
      P.stroke(255, col);
      P.rect(0, 0, 500, 1200);
    } else {
      if (isDead>=1) { 
        P.translate(x, y, z);
        P.stroke(255, map(z, -2000, 800, 150, 255));
        P.fill(255);
        P.ellipse(0, 0, 50+isDead*2, 50+isDead*2);
      } else { 
        P.translate(x, y, z);
        P.stroke(255, col);      
        P.strokeWeight(2);

        P.noFill();
        //  P.arc(0, 0, 50, 50, )
        P.arc(0, 0, 75, 75, 0, radians(constrain(map(z, -500, 800, 0, 360), 0, 360)), OPEN);

        P.fill(255, map(z, -2000, 1600, 0, 255));
        P.textSize(4);
        P.text(x, 0, 40);
        P.text(y, 0, 50);
        P.text(z, 0, 60);
      }
    }
    P.popMatrix();
  }
}
