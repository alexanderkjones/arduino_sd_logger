//SD Logger
#include <SD.h>

//Set up variables using the SD utility library functions:
Sd2Card card;
SdVolume volume;
SdFile root;
SdFile file;

// SD Pins
int cardDetect = 8, chipSelect = 10, cardInit = false;

//Sensor Pins
int ldrPin = 0, tmpPin = 1;

// Initialize Log Resolution in millis
int logDelay = 1000;

void setup()
{
  Serial.begin(9600);
  
  sd_card_pinMode_set();
}

void loop(){
  // See if Card is Present
  if (sd_card_present()) {

    // Attempt to initialize card
     try_initialize_card()
    
    // initialize a FAT volume
  if (!volume.init(card)) Serial.println("volume.init");
  
  // open the root directory
  if (!root.openRoot(volume)) Serial.println("openRoot");
  
    //Grab Data
    String dataString = "";
    
    dataString += "Temp!: ";
    dataString += analogRead(tmpPin);
    dataString += " Light: ";
    dataString += analogRead(ldrPin);
    
    Serial.println(dataString);
    
    file.open(root, "TEST.txt", O_CREAT | O_APPEND | O_WRITE);
    if(file.isOpen()){
      Serial.println("File OPEN");
      file.println(dataString);
      file.close();
    }else{
      Serial.println("File Error");
    }
  }
  else{
    cardInit = false;
  }
  
  delay(logDelay);
}




