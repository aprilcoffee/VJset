float kickSize, snareSize, hatSize;
float beatLighten = 0;
float audioAmpScale = 1000;
void soundDetectionInit() {
  minim = new Minim(this);
  in = minim.getLineIn();

  analyisBeat = new BeatDetect( in.bufferSize(), in.sampleRate() );
  analyisBeat.setSensitivity(100);
  beat = new BeatDetect();
  beat.setSensitivity(400);  

  fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  fftLin.logAverages( 22, 3 );
  kickSize = snareSize = hatSize = 16;
}

void detectBeat() {

  isKick = false;
  isBeat = false;
  isSnare = false;
  isHat = false;
  
  // draw a green rectangle for every detect band
  // that had an onset this frame
  float rectW = width / analyisBeat.detectSize();
  for (int i = 0; i < analyisBeat.detectSize(); ++i)
  {
    // test one frequency band for an onset
    /*
    if ( analyisBeat.isOnset(i) )
     {
     fill(0, 200, 0);
     //rect( i*rectW, 0, rectW, height);
     for (int x=0; x<rectW; x++) {
     for (int y=0; y<height; y++) {
     color c = (color)glitchImg.get((int)map(i*rectW+x, 0, width, 0, glitchImg.width), (int)map(y, 0, height, 0, glitchImg.height));
     set(int(i*rectW+x), y, c);
     }
     }
     }
     }*/

    // draw an orange rectangle over the bands in 
    // the range we are querying
    int lowBand = 5;
    int highBand = 15;
    // at least this many bands must have an onset 
    // for isRange to return true
    int numberOfOnsetsThreshold = 4;
    /* if ( analyisBeat.isRange(lowBand, highBand, numberOfOnsetsThreshold) )
     {
     fill(232, 179, 2, 200);
     rect(rectW*lowBand, 0, (highBand-lowBand)*rectW, height);
     }
     
     if ( analyisBeat.isKick() ) {
     kickSize = 32;
     }
     if ( analyisBeat.isSnare() ) {
     snareSize = 32;
     }
     if ( analyisBeat.isHat() ) {
     hatSize = 32;
     }
     
     
     fill(255);
     
     textSize(kickSize);
     text("KICK", width/4, height/2);
     
     textSize(snareSize);
     text("SNARE", width/2, height/2);
     
     textSize(hatSize);
     text("HAT", 3*width/4, height/2);
     
     */
  }
  if ( analyisBeat.isKick() ) {
    println("kick");
    isKick = true;
  }
  if ( analyisBeat.isSnare() ) {
    println("Snare");
    isSnare = true;
  }
  if ( analyisBeat.isHat() ) {
    println("Hat");
    isHat = true;
  }
  if (beat.isOnset()) {
    println("Beat");
    isBeat = true;
  }

  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;

  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
