
void soundCheck() {

  totalAmp = 0;

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

  int w = int( width/fftLin.avgSize() );
  for (int i = 0; i < fftLin.avgSize(); i++)
  {
    centerFrequency    = fftLin.getAverageCenterFrequency(i);
    // how wide is this average in Hz?
    float averageWidth = fftLin.getAverageBandWidth(i);   
    // we calculate the lowest and highest frequencies
    // contained in this average using the center frequency
    // and bandwidth of this average.
    float lowFreq  = centerFrequency - averageWidth/2;
    float highFreq = centerFrequency + averageWidth/2;

    // freqToIndex converts a frequency in Hz to a spectrum band index
    // that can be passed to getBand. in this case, we simply use the 
    // index as coordinates for the rectangle we draw to represent
    // the average.
    int xl = (int)fftLin.freqToIndex(lowFreq);
    int xr = (int)fftLin.freqToIndex(highFreq);

    // if the mouse is inside of this average's rectangle
    // print the center frequency and set the fill color to red
    /*if ( mouseX >= xl && mouseX < xr )
     {
     fill(255, 0, 0, 255);
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
     stroke(50);
     rect( xl, height-200, xr, height-200 - fftLin.getAvg(i)*spectrumScale );
     textAlign(LEFT);
     textSize(15);
     text(nfc(fftLin.getAvg(i)*spectrumScale, 3), i*w, height-100);*/
  }



  //println(totalAmp);
}
