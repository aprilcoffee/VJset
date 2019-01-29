
import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioInput in;
BeatDetect analyisBeat;
BeatDetect beat;
BeatListener bl;
FFT fftLin;

float camX, camY, camZ;

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

//Terrain
float[][] terrainLeft;
float[][] terrainRight;
float[] audioAmp;
int cols, rows;
int scl = 20;
int w = 1000;
int h = 2000;



PGraphics starField;
ArrayList<Star> stars = new ArrayList<Star>();

int starWidth = 800;
int starHeight = 450;

PShape spaceShip;

PGraphics controlinterface;

float beatLighten = 0;


float audioAmpScale = 1000;

ArrayList<Tunnel> tunnel;
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
  //spaceShip = loadShape("obj/ship_striker.obj");



  starField = createGraphics(800, 450, P3D);
  controlinterface = createGraphics(800, 600, P3D);



  // make a new beat listener, so that we won't miss any buffers for the analysis
  //bl = new BeatListener(analyisBeat, in);  

  terrainInit();

  font_trench = createFont("font/trench100free.ttf", 32);   
  textFont(font_trench);
  textAlign(CENTER);

  tunnel = new ArrayList<Tunnel>();


  img = loadImage("Pixels.jpg");
  frameRate(30);
}

void draw()
{
  beat.detect(in.mix);
  analyisBeat.detect(in.mix);
  leapmotionScan();

  background(0);
  //camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);

  //  rectMode(CENTER);


  soundwaveSphere();
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
