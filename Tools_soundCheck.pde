
float height23;
float spectrumScale = 10;

float totalAmp = 0;

float totalAmp_Min = 6000;
float totalAmp_Max = 0;

float f_Low = 0;
float f_Mid = 0;
float f_High = 0;
float f_total = 0;

float freqLow_Min = 2000;
float freqLow_Max = 0;
float freqMid_Min = 2000;
float freqMid_Max = 0;
float freqHigh_Min = 2000;
float freqHigh_Max = 0;

void soundAdjestReset() {
  freqLow_Min = 2000;
  freqLow_Max = 0;
  freqMid_Min = 2000;
  freqMid_Max = 0;
  freqHigh_Min = 2000;
  freqHigh_Max = 0;
  totalAmp_Min = 6000;
  totalAmp_Max = 0;
  
  println(f_total);
}

void soundCheck() {

  totalAmp = 0;
  float freqLow = 0;
  float freqMid = 0;
  float freqHigh = 0;
  float freqTotal = 0;

  rectMode(CORNERS);
  float centerFrequency = 0;
  fftLin.forward( in.mix );
  //fftLog.forward( in.mix );

  pushMatrix();
  translate(0, height/2);
  stroke(1);
  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    //line( i, 50 + in.left.get(i)*200, i+1, 50 + in.left.get(i+1)*200 );
    //line( i, 150 + in.right.get(i)*200, i+1, 150 + in.right.get(i+1)*200 );
    totalAmp += abs(in.mix.get(i)*100);
  }
  popMatrix();

  //int w = int( width/fftLin.avgSize() );
  for (int i = 0; i < fftLin.avgSize(); i++)
  {
    //centerFrequency    = fftLin.getAverageCenterFrequency(i);
    // how wide is this average in Hz?
    //float averageWidth = fftLin.getAverageBandWidth(i);   
    // we calculate the lowest and highest frequencies
    // contained in this average using the center frequency
    // and bandwidth of this average.
    //float lowFreq  = centerFrequency - averageWidth/2;
    //float highFreq = centerFrequency + averageWidth/2;

    // freqToIndex converts a frequency in Hz to a spectrum band index
    // that can be passed to getBand. in this case, we simply use the 
    // index as coordinates for the rectangle we draw to represent
    // the average.
    //int xl = (int)fftLin.freqToIndex(lowFreq);
    //int xr = (int)fftLin.freqToIndex(highFreq);
    // if the mouse is inside of this average's rectangle
    // print the center frequency and set the fill color to red
    /*
    blendMode(BLEND);
     if ( mouseX >= xl && mouseX < xr )
     {
     fill(255);
     textAlign(LEFT);
     textSize(25);
     text("Logarithmic Average Center Amplitude: " + totalAmp, 5, height-200 - 75);
     text("Logarithmic Average Center Index: " + i, 5, height-200 - 50);
     text("Logarithmic Average Center Frequency: " + centerFrequency, 5, height-200 - 25);
     
     fill(255, 0, 0);
     } else
     {
     fill(30);
     }
     // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
     fill(255);
     stroke(255);
     rect( xl, height-200, xr, height-200 - fftLin.getAvg(i)*spectrumScale );
     textAlign(LEFT);
     textSize(15);
     text(nfc(fftLin.getAvg(i)*spectrumScale, 3), i*w, height-100);
     */
    if (i <= 8)freqLow += fftLin.getAvg(i);
    else if (i > 8 && i <= 20)freqMid += fftLin.getAvg(i);
    else if (i > 20)freqHigh += fftLin.getAvg(i);

    freqTotal += fftLin.getAvg(i);
  }
  /*
  print(freqTotal);
   print('\t');
   print(nfc(freqLow, 3));
   print('\t');
   print(nfc(freqMid, 3));
   print('\t');
   println(nfc(freqHigh, 3));
   */

  if (freqTotal <= totalAmp_Min)totalAmp_Min = freqTotal;
  if (freqTotal >= totalAmp_Max)totalAmp_Max = freqTotal;

  if (freqLow <= freqLow_Min)freqLow_Min = freqLow;
  if (freqLow >= freqLow_Max)freqLow_Max = freqLow;

  if (freqMid <= freqMid_Min)freqMid_Min = freqMid;
  if (freqMid >= freqMid_Max)freqMid_Max = freqMid;

  if (freqHigh <= freqHigh_Min)freqHigh_Min = freqHigh;
  if (freqHigh >= freqHigh_Max)freqHigh_Max = freqHigh;

  f_Low = norm(freqLow, freqLow_Min, freqLow_Max);
  f_Mid = norm(freqMid, freqMid_Min, freqMid_Max);
  f_High = norm(freqHigh, freqHigh_Min, freqHigh_Max);
  f_total = norm(freqTotal, totalAmp_Min, totalAmp_Max);

  int showVol = constrain(int(map(f_total, 0, 1, -1, 5)), 0, 5);
  int showVol_mid = constrain(int(map(f_Mid, 0, 1, -1, 5)), 0, 5);
  int showVol_high = constrain(int(map(f_High, 0, 1, -1, 5)), 0, 5);

  int channel = 11;
  for (int i=0; i<showVol_mid; i++) {
    int number = 11+i;
    int value = 60;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }
  for (int i =showVol_mid; i<4; i++) {
    int number = 11+i;
    int value = 0;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  } 
  for (int i=0; i<showVol_high; i++) {
    int number = 15+i;
    int value = 63;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }
  for (int i =showVol_high; i<4; i++) {
    int number = 15+i;
    int value = 0;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }
  channel = 12;
  for (int i=0; i<showVol; i++) {
    int number = 11+i;
    int value = 15;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }
  for (int i =showVol; i<8; i++) {
    int number = 11+i;
    int value = 0;
    myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }


  //println(totalAmp);
}
