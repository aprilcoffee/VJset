import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
BeatDetect analyisBeat;
BeatDetect beat;
BeatListener bl;
FFT fftLin;
Midi midi;

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
//ArrayList<Tunnel> tunnel;

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
  size(1280, 800, P3D);
  blendMode(ADD);
  hint(DISABLE_DEPTH_TEST);
  colorMode(HSB);

  spaceBG = loadImage("spaceBG.png");
  spaceShip = loadShape("obj/ship_striker.obj");
  glitchImg = loadImage("Pixels.jpg");
  spaceshipPos = new PVector();
  spaceImg = new PImage[photoLength];
  spaceImgBW = new PImage[photoLength];
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  } 


  //controlinterface = createGraphics(800, 600, P3D);
  PG_starField = createGraphics(800, 450, P3D);
  PG_terrain = createGraphics(1280, 800, P3D);
  PG_atanWave = createGraphics(1280, 800, P3D);
  PG_soundwaveSphere = createGraphics(1280, 800, P3D);
  PG_spaceShip = createGraphics(800, 600, P3D);
  PG_floatingText = createGraphics(1280, 800, P3D);
  PG_particleFollow = createGraphics(1280, 800, P3D);
  PG_planet = createGraphics(1280, 800, P3D);
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

  frameRate(30);
  //tunnel = new ArrayList<Tunnel>()
  background(0);
}

void draw()
{
  background(0);
  beat.detect(in.mix);
  analyisBeat.detect(in.mix);
  leapmotionScan();
  soundCheck();
  detectBeat();
  if (frameCount%6000==0)soundAdjestReset();

  camA = handRight.x;
  camT = handRight.y;
  camDis = handRight.z;

  // println(frameCount);
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));


  hint(DISABLE_DEPTH_TEST);
  ////PG_starField
  if (midi.layerToggle[0]) {
    tint(midi.layerTint[0]);
    image(drawStarField(PG_starField), 0, 0, width, height);
  }
  ////PG_terrain
  if (midi.layerToggle[1]) {
    tint(midi.layerTint[1]);
    image(drawTerrain(PG_terrain), 0, 0, width, height);
  }
  ////PG_atanWave
  if (midi.layerToggle[2]) {
    tint(midi.layerTint[2]);
    image(drawatanWave(PG_atanWave), 0, 0, width, height);
  }
  ////PG_soundwaveSphere
  if (midi.layerToggle[3]) {
    tint(midi.layerTint[3]);
    image(drawSoundwaveSphere(PG_soundwaveSphere), 0, 0, width, height);
  }
  ////PG_spaceShip
  if (midi.layerToggle[4]) {
    tint(midi.layerTint[4]);
    image(drawSpaceShip(PG_spaceShip), 0, 0, width, height);
  }
  //PG_floatingText
  if (midi.layerToggle[5]) {
    tint(midi.layerTint[5]);
    image(drawFloatingText(PG_floatingText), 0, 0, width, height);
  }
  //PG_particleFollow
  if (midi.layerToggle[6]) {
    tint(midi.layerTint[6]);
    image(drawParticleFollow(PG_particleFollow), 0, 0, width, height);
  }
  if (midi.layerToggle[7]) {
    tint(midi.layerTint[7]);
    image(drawPlanet(PG_planet), 0, 0, width, height);
  }
}
