import ddf.minim.*;
import ddf.minim.analysis.*;
Runtime runtime;
Minim minim;
AudioInput in;
BeatDetect analyisBeat;
BeatDetect beat;
BeatListener bl;
FFT fftLin;
Midi midi;
import processing.video.*;

Movie movie;


boolean soundReset;

boolean isBeat;
boolean isKick;
boolean isSnare;
boolean isHat;

float camX, camY, camZ;
float camA, camT, camDis;
PFont font_trench;

PImage glitchImg;
PImage spaceBG;
PImage[] spaceImg;
PImage[] spaceImgBW;
int photoLength =25;

PGraphics PG_starField;
PGraphics PG_terrain;
PGraphics PG_atanWave;
PGraphics PG_soundwaveSphere;
PGraphics PG_spaceShip;
PGraphics PG_floatingText;
PGraphics PG_particleFollow;
PGraphics PG_planet;
//PGraphics controlinterface;

/*
 if ( analyisBeat.isKick() ) {
 }
 if ( analyisBeat.isSnare() ) {
 }
 if ( analyisBeat.isHat() ) {
 }
 if (beat.isOnset()) {
 }
 
 */
void setup()
{
  //size(1920, 1080, P3D);
  fullScreen(P3D,2);

  blendMode(ADD);
  hint(DISABLE_DEPTH_TEST);
  colorMode(HSB);

  spaceBG = loadImage("spaceBG.png");
  spaceShip = loadShape("obj/penis.obj");
  glitchImg = loadImage("Pixels.jpg");
  spaceshipPos = new PVector();
  spaceImg = new PImage[photoLength];
  spaceImgBW = new PImage[photoLength];
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  } 
  tunnel = new ArrayList<Tunnel>();



  //controlinterface = createGraphics(800, 600, P3D);
  PG_starField = createGraphics(1920, 1080, P3D);
  PG_terrain = createGraphics(1920, 1080, P3D);
  PG_atanWave = createGraphics(1920, 1080, P3D);
  PG_soundwaveSphere = createGraphics(1920, 1080, P3D);
  PG_spaceShip = createGraphics(1920, 1080, P3D);
  PG_floatingText = createGraphics(1280, 800, P3D);
  PG_particleFollow = createGraphics(1920, 1080, P3D);
  PG_planet = createGraphics(1920, 1080, P3D);
  // make a new beat listener, so that we won't miss any buffers for the analysis
  //bl = new BeatListener(analyisBeat, in);  
  font_trench = createFont("font/trench100free.ttf", 32);   
  textFont(font_trench);
  textAlign(CENTER);

  leapmotionInit();
  midiContollerInit();  
  soundDetectionInit();  
  soundAdjestReset();
  terrainInit();
  particlesInit(PG_particleFollow);
  planetInit(PG_planet);
  starInit();
  movie = new Movie(this, "loop.mp4");
  movie.loop();

  frameRate(30);
  background(0);


  runtime = java.lang.Runtime.getRuntime();
}

void draw()
{


  background(0);
  beat.detect(in.mix);
  analyisBeat.detect(in.mix);
  leapmotionScan();
  soundCheck();
  detectBeat();

  // if (frameCount%6000==0)soundAdjestReset();

  camA = handRight.x;
  camT = handRight.y;
  camDis = handRight.z;

  // frameCount);
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));

  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  //imageMode(CORNER);
  //hint(DISABLE_DEPTH_TEST);

  //blendMode(ADD);

  ////PG_starField
  if (midi.layerToggle[0]) {
    tint(midi.layerTint[0]);
    blendMode(ADD);
    image(drawStarField(PG_starField), 0, 0, width, height);
  }
  ////PG_terrain
  if (midi.layerToggle[1]) {
    tint(midi.layerTint[1]);
    blendMode(ADD);
    image(drawTerrain(PG_terrain), 0, 0, width, height);
  }
  ////PG_atanWave
  if (midi.layerToggle[2]) {
    tint(midi.layerTint[2]);
    blendMode(ADD);
    image(drawatanWave(PG_atanWave), 0, 0, width, height);
  }
  ////PG_soundwaveSphere
  if (midi.layerToggle[3]) {
    tint(midi.layerTint[3]);
    blendMode(ADD);
    image(drawSoundwaveSphere(PG_soundwaveSphere), 0, 0, width, height);
  }
  //PG_floatingText
  if (midi.layerToggle[5]) {
    tint(midi.layerTint[5]);
    blendMode(ADD);
    image(drawFloatingText(PG_floatingText), 0, 0, width, height);
  }
  //PG_particleFollow
  if (midi.layerToggle[6]) {
    tint(midi.layerTint[6]);
    blendMode(ADD);
    image(drawParticleFollow(PG_particleFollow), 0, 0, width, height);
  }
  ////PG_spaceShip
  if (midi.layerToggle[4]) {
    tint(midi.layerTint[4]);
    blendMode(BLEND);
    image(drawSpaceShip(PG_spaceShip), 0, 0, width, height);
  }
  if (midi.layerToggle[7]) {
    tint(midi.layerTint[7]);
    blendMode(BLEND);
    image(drawPlanet(PG_planet), 0, 0, width, height);
    if (midi.control[7][2] > 30) {
      translate(random(-f_total*10, f_total*10), random(-f_total*10, f_total*10));
      tint(midi.layerTint[7] * norm(midi.control[7][2], 0, 127));

      pushMatrix();
      if (midi.control[7][2]>64) {
        translate(600 * abs(sin(radians(frameCount + 30*f_High))), 0);
        image(PG_planet, -width/2+200, -height/2, width, height);
      }
      popMatrix();

      pushMatrix();
      if (midi.control[7][2]>64) {
        translate(-600 * abs(sin(radians(frameCount + 27*f_Mid))), 0);
        image(PG_planet, width/2, height/2-200, width, height);
      }
      popMatrix();
    }
  }

  keyTap = false;

  if (soundReset==true) {
    soundAdjestReset();
    soundReset=false;
  }


  if (frameCount % 3600 ==0)runtime.gc();
}
void movieEvent(Movie m) {
  m.read();
}
