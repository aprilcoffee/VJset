
import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioInput in;
BeatDetect analyisBeat;
BeatDetect beat;
BeatListener bl;
FFT fftLin;

float camX, camY, camZ;
PVector spaceshipPos;

float height23;
float spectrumScale = 10;
float totalAmp = 0;

float kickSize, snareSize, hatSize;
PFont font_trench;

PImage img;
PImage spaceBG;

boolean TerrainRandom = false;
boolean terrainRandomTrigger = false;
int TerrainMode = 2;


float camA;
float camT; 
float camDis; 

PShape spaceShip;

float beatLighten = 0;
float audioAmpScale = 1000;
//ArrayList<Tunnel> tunnel;

PGraphics PG_starField;
PGraphics PG_terrain;
PGraphics PG_planet;
PGraphics PG_atanWave;
PGraphics PG_soundwaveSphere;
PGraphics PG_spaceShip;
PGraphics PG_floatingText;
PGraphics PG_particleFollow;

//PGraphics controlinterface;


void setup()
{
  size(1280, 800, P3D);
  leapmotionInit();
  midiContollerInit();  
  soundDetectionInit();

  blendMode(ADD);
  hint(DISABLE_DEPTH_TEST);
  colorMode(HSB);


  spaceBG = loadImage("spaceBG.png");
  spaceShip = loadShape("obj/ship_striker.obj");
  spaceshipPos = new PVector();
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

  terrainInit();

  font_trench = createFont("font/trench100free.ttf", 32);   
  textFont(font_trench);
  textAlign(CENTER);

  //tunnel = new ArrayList<Tunnel>();

  img = loadImage("Pixels.jpg");
  frameRate(30);
  background(0);
}

void draw()
{
  background(0);
  beat.detect(in.mix);
  analyisBeat.detect(in.mix);
  leapmotionScan();
  soundCheck();

  camA = handRight.x;
  camT = handRight.y;
  camDis = handRight.z;

  // println(frameCount);
  camX = camDis*sin(radians(camA))*cos(radians(camT));
  camY = camDis*sin(radians(camT));
  camZ = camDis*cos(radians(camA))*cos(radians(camT));

  ////PG_starField
  hint(DISABLE_DEPTH_TEST);
  tint(255);
  //image(drawStarField(PG_starField), 0, 0, width, height);

  ////PG_terrain
  tint(255);
  //image(drawTerrain(PG_terrain), 0, 0, width, height);

  ////PG_atanWave
  tint(255);
  //image(drawatanWave(PG_atanWave), 0, 0, width, height);

  ////PG_soundwaveSphere
  tint(255);
  //image(drawSoundwaveSphere(PG_soundwaveSphere), 0, 0, width, height);

  ////PG_spaceShip
  tint(255);
  //image(drawSpaceShip(PG_spaceShip), 0, 0, width, height);

  ////PG_spaceShip
  tint(255);
  //image(drawSpaceShip(PG_spaceShip), 0, 0, width, height);

  //PG_floatingText
  tint(255);
  //image(drawFloatingText(PG_floatingText), 0, 0, width, height);

  //PG_particleFollow
  tint(255);
  image(drawParticleFollow(PG_particleFollow), 0, 0, width, height);



  //for (int s=0; s<tunnel.size(); s++) {
  //  tunnel.get(s).update();
  //  tunnel.get(s).show();
  //  if (tunnel.get(s).z > 1000)tunnel.remove(s);
  //}
}
class Tunnel {
  float x, y, z;
  float len;
  Tunnel() {
    x = 0;
    y = 0;
    z = -2000;
    len = 500;
  }
  void update() {
    z+=30;
  }
  void show() {
    noFill();
    strokeWeight(5);
    stroke(255);
    translate(0, 0, z);
    rect(0, 0, 500, 1000);
  }
}
void keyReleased() {
  tunnel.add(new Tunnel());
  //changeCamera = 1;
}
