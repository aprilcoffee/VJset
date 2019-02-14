ArrayList<Star> stars = new ArrayList<Star>();
int starWidth = 1920;
int starHeight = 1080;
float spin = 0;
float currentSpin = 0;


boolean photoTrigger = false;
boolean photoTriggerImageRect = false;
boolean photoTriggerImageBW = false;
boolean photoTriggerImage = true;
boolean photoKill = false;
boolean photoSpin = false;
boolean glitchTrigger = false;
boolean glitchEnd = false;
int showImageCounterAfterSpin = 0;
ArrayList<SpaceImages> spaceImages;
boolean spinMoveFaster = false;

int imageFlagtemp = int(random(photoLength));


void starInit() { 
  spaceImg = new PImage[photoLength];
  spaceImgBW = new PImage[photoLength];
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  }  
  spaceImages = new ArrayList<SpaceImages>();
}
PGraphics drawStarField(PGraphics P) {
  P.beginDraw();
  if (midi.control[0][0] > 100) {
    if (f_total<0.4) {
      P.background(0, 0);
    } else {
      if (random(map(f_total, 0.4, 1, 0, 100)) > 30);
      else P.background(0, 0);
    }
  } else {
    P.background(0, 0);
  }
  P.blendMode(ADD);
  P.hint(DISABLE_DEPTH_TEST);
  P.pushMatrix();
  P.tint(100+100*f_High);
  P.imageMode(CENTER);
  if (midi.control[0][2] > 35 && midi.control[0][2] <= 70) {
    P.image(spaceBG, P.width/2, P.height/2, P.width, P.height);
  } else if (midi.control[0][2] > 70&&midi.control[0][2] < 100) {
    P.image(imageGlitch(spaceBG), P.width/2, P.height/2, P.width, P.height);
    spaceBG = loadImage("spaceBG.png");
  } else if (midi.control[0][2]>=100 && midi.control[0][2]<120) { 
    P.image(spaceImgBW[imageFlagtemp], P.width/2, P.height/2, P.width, P.height);
  } else if(midi.control[0][2]>=120){
    P.image(movie, P.width/2, P.height/2, P.width, P.height) ;
  }

  if (isHat) {
    imageFlagtemp = int(random(photoLength));
  }
  P.popMatrix();
  for (int s=0; s<f_total * 5 * midi.control[0][0]/4; s++) {
    stars.add(new Star(10, 100));
  }
  P.translate(starWidth/2, starHeight/2);
  P.pushMatrix();
  currentSpin += (spin - currentSpin)*0.1;
  P.rotate(radians(currentSpin));
  for (int s=0; s<stars.size(); s++) {
    stars.get(s).update();
    if (stars.get(s).pos.z < 1) {
      stars.remove(s);
      continue;
    }
    stars.get(s).show(P);
  }  
  P.popMatrix();


  P.blendMode(BLEND);
  for (int s=0; s<spaceImages.size(); s++) {
    spaceImages.get(s).update();
    spaceImages.get(s).showImage(P);

    if (spaceImages.get(s).imageSizeY<12) {
      spaceImages.remove(s);
    }
  }
  if (photoSpin==true)
    showImageCounterAfterSpin++;

  if (isBeat) {
    if (random(2)>1) {
      for (int s=0; s<spaceImages.size(); s++) {
        spaceImages.get(s).kill();
      }
      int ran = int(random(5));
      if (ran == 0 ) {
        photoTriggerImageRect = true;
        photoTriggerImageBW = false;
        photoTriggerImage = false;
      } else if (ran == 1 || ran ==2) {
        photoTriggerImageRect = false;
        photoTriggerImageBW = true;
        photoTriggerImage = false;
      } else {
        photoTriggerImageRect = false;
        photoTriggerImageBW = false;
        photoTriggerImage = true;
      }
    }
  }

  spinMoveFaster=isKick;

  if (isHat) {
    if (random(127) < midi.control[0][1]) {
      int dir = 0;
      if (random(2)>1) {
        dir = 1;
      } else {
        dir = 0;
      }
      if (photoTriggerImageRect==true) {
        spaceImages.add(new SpaceImages(500+random(-400, 400), 
          random(-300, 300), 
          dir, random(-500, 500), 0));
      } else if (photoTriggerImageBW==true) {
        spaceImages.add(new SpaceImages(500+random(-400, 400), 
          random(-300, 300), 
          dir, random(-500, 500), 1));
      } else if (photoTriggerImage==true) {
        spaceImages.add(new SpaceImages(500+random(-400, 400), 
          random(-300, 300), 
          dir, random(-500, 500), 2));
      }
      photoTrigger = false;
    }
  }

  P.endDraw();
  return P;
}
class Star {
  PVector pos = new PVector();
  float pz;
  float speed;
  float R, theta, v, proportion, proportionV;
  float ssx, ssy;
  Star(int eSpeed, float _proportionV) {
    pos.x = random(-starWidth/4, starWidth/4);
    pos.y = random(-starHeight/4, starHeight/4);
    pos.z = random(starWidth);
    pz = pos.z;
    speed = eSpeed;
    R = 100;
    theta = random(360);
    v =  random(1, 2);
    proportion = 0;
    proportionV = _proportionV;
  }
  void update() {
    pos.z -= speed;

    if (isBeat) {
      pos.z  -= speed*4;
    }
    //if (pos.z < 0.5) {
    //  pos.z = starWidth;
    //  pos.x = random(-starWidth, starWidth);
    //  pos.y = random(-starHeight, starHeight);
    //  pz = pos.z;
    //}
    theta = theta + v;

    //if (starGoCenter==true) {
    //  if (proportion < 1) {
    //    proportion = proportion+proportionV;
    //  } else {
    //    proportion = 1;
    //  }
    //}
  }
  void show(PGraphics P) {
    float sx = map(pos.x/pos.z, 0, 1, 0, starWidth);
    float sy = map(pos.y/pos.z, 0, 1, 0, starHeight);
    float r = map(pos.z, 0, starWidth, 2, 0.3);
    float px = map(pos.x/pz, 0, 1, 0, starWidth);
    float py = map(pos.y/pz, 0, 1, 0, starHeight);

    float x = (1-proportion)*px+proportion*R*cos(radians(theta));
    float y = (1-proportion)*py+proportion*R*sin(radians(theta));
    float z = R*sin(radians(frameCount));

    float ssx = (1-proportion)*sx+proportion*R*cos(radians(theta-v));
    float ssy = (1-proportion)*sy+proportion*R*sin(radians(theta-v));
    float ssz = R*sin(radians(frameCount-1));

    P.stroke(255, 150);
    P.strokeWeight(r);
    P.line(x, y, z, ssx, ssy, ssz);
    pz = pos.z;
  }
}

PImage imageGlitch(PImage P) {
  PImage temp = P;
  temp.loadPixels();
  colorMode(RGB);
  color randomColor = color(random(255), random(255), random(255), 255);
  /*if (random(100)<60) {
   for (int y=int(random(temp.height)); y<random(temp.height); y++) {
   for (int x=0; x<temp.width; x++) {
   // get the color for the pixel at coordinates x/y
   color pixelColor = temp.pixels[y + x * temp.height];
   // percentage to mix
   float mixPercentage = .5 + random(50)/25;
   // mix colors by random percentage of new random color
   //temp.pixels[y + x * temp.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
   temp.pixels[x + y * temp.width] = glitchImg.get(int(map(x, 0, temp.width, 0, glitchImg.width)), int(map(y, 0, temp.height, 0, glitchImg.height)));
   }
   }
   }*/
  /*
  float rectW = temp.width / analyisBeat.detectSize();
   for (int i=0; i<analyisBeat.detectSize(); i++) {
   if ( analyisBeat.isOnset(i) )
   {
   //rect( i*rectW, 0, rectW, height);
   for (int x=0; x<rectW; x++) {
   for (int y=0; y<temp.height; y++) {
   color c = (color)glitchImg.get((int)map(i*rectW+x, 0, width, 0, glitchImg.width), (int)map(y, 0, height, 0, glitchImg.height));
   
   //temp.pixels[x + y * temp.width] = glitchImg.get(int(map(x, 0, temp.width, 0, glitchImg.width)), int(map(y, 0, temp.height, 0, glitchImg.height)));
   
   temp.set(int(i*rectW+x), y, c);
   }
   }
   }
   }*/

  temp.updatePixels();
  if (random(100)<50) {
    for (int s=0; s<20; s++) {
      int x1 = 0;
      int y1 = floor(random(temp.height));

      int x2 = round(x1 + random(-30, 30));
      int y2 = round(y1 + random(-4, 4));

      int w = temp.width;
      int h = floor(random(30));
      temp.set(x2, y2, temp.get(x1, y1, w, h));
    }
  }
  return temp;
}

class SpaceImages {
  float photoX, photoY, photoZ;
  float r = 300;
  float angle = 90;
  float imageSizeX = random(80, 200);
  float imageSizeY = imageSizeX/4*3;
  float ori_imageSizeY = imageSizeY;
  float ori_imageSizeX = imageSizeX;
  int imageFlag = int(random(photoLength));

  boolean dead = false;
  float textX;
  float textY;
  float photoXOri;
  float photoYOri;
  int dir;
  float spin = 0;
  float spinAdjust;
  float spinRadians;
  float textEasing = 0.3; 
  int imageMode = 0;
  float spinAdjustOri;
  float textSize;
  SpaceImages(float ex, float ey, int edir, float targetY, int eimageMode) {
    photoX = ex;
    photoY = ey;
    photoZ = 0;
    dir = edir;
    imageMode = eimageMode;
    if (dir==0)photoX = -photoX;
    spinRadians = photoX;

    textX = photoX;
    textY = photoY + imageSizeY/2 + 10;

    photoXOri = 0;
    photoYOri = 0;

    // 0 blank 1 BWImg 2 colImg 3 spin
    if (photoSpin == true) {
      spin = 90 + random(2*showImageCounterAfterSpin);
      spinAdjust = random(0.1, 0.5);
      spinAdjustOri = spinAdjust;
    } else {
      spin = 90;
      spinAdjust = 0;
      spinAdjustOri = spinAdjust;
    }
  }
  void update() {
    imageSizeY = ori_imageSizeY*sin(radians(angle));
    if (dead) { 
      imageSizeX = ori_imageSizeX + tan(radians(angle+45));
      angle +=5;
    }
    photoX = spinRadians*sin(radians(spin));
    photoZ = spinRadians*cos(radians(spin));
    if (spinMoveFaster==true) {
      spinAdjust = spinAdjustOri*3;
    } else {
      spinAdjust += (spinAdjustOri-spinAdjust)*0.5;
      spin += spinAdjust;
    }
    photoXOri += (photoX - photoXOri)*textEasing;
    photoYOri += (photoY - photoYOri)*textEasing;
  }
  void kill() {
    dead = true;
  }
  void showImage(PGraphics P) {
    P.rectMode(CENTER);
    P.noFill();
    P.pushMatrix();
    P.translate(photoX, photoY, photoZ);
    P.tint(255);
    if (glitchTrigger==true) {
      if (imageMode == 1) {
        P.image(imageGlitch(spaceImgBW[imageFlag]), 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        P.image(imageGlitch(spaceImg[imageFlag]), 0, 0, imageSizeX, imageSizeY);
      }
    } else if (photoSpin==true) {
      if (imageMode == 1) {
        P.image(spaceImgBW[imageFlag], 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        P.image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
      }
    } else {
      if (imageMode == 0) {
        //rect(0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 1) {
        P.image(spaceImgBW[imageFlag], 0, 0, imageSizeX, imageSizeY);
        P.stroke(100);
        P.rect(0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        P.image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
        P.stroke(100);
        P.rect(0, 0, imageSizeX, imageSizeY);
      }
    }
    P.popMatrix();
    P.textSize(12 + f_Mid*10);
    P.fill(255);

    P.text(nfc(photoXOri, 3), textX, textY);
    P.text(nfc(photoYOri, 3), textX, textY+20);

    if (dir==1) {
      P.stroke(255, 100);
      P.line(photoX-imageSizeX/2, photoY, photoZ, textX, textY, 0);
    } else {
      P.stroke(255, 100);
      P.line(photoX+imageSizeX/2, photoY, photoZ, textX, textY, 0);
    }
  }
}
