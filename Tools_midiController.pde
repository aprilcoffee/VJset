import themidibus.*; 
MidiBus myBus; 
void midiContollerInit() {
  MidiBus.list();
  myBus = new MidiBus(this, "Launch Control XL", "Launch Control XL");
  for (int channel=12; channel<=14; channel++) {
    for (int number=11; number<=18; number++) {
      int value = 0;
      myBus.sendControllerChange(channel, number, value); // Send a controllerChange
    }
  }
}
void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
