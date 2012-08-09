//Unique Temp + Photo JSON SD Logger
/*
  The Goal of this project is create an SD logger with a unique ID
 that logs temperature and light intensity data in JSON format for
 use in web application
 */

#include <EEPROM.h>
#include <SD.h>
#include <Time.h>
#include "Wire.h"

#define DS1307_I2C_ADDRESS 0x68  // This is the I2C address
// Arduino version compatibility Pre-Compiler Directives
#if defined(ARDUINO) && ARDUINO >= 100   // Arduino v1.0 and newer
  #define I2C_WRITE Wire.write 
  #define I2C_READ Wire.read
#else                                   // Arduino Prior to v1.0 
  #define I2C_WRITE Wire.send 
  #define I2C_READ Wire.receive
#endif

//Serial Container
String ee_serial = "";

//Set up variables using the SD utility library functions:
Sd2Card card;
SdVolume volume;
SdFile root;
SdFile file;

// Initialize Sensors
int ldrPin = 0;
int tmpPin = 1;

// SD Link
int cardDetect = 8;
int chipSelect = 10;
int cardInit = false;

// Initialize Log Resolution in millis
int logDelay = 1000;

void setup()
{
  Serial.begin(9600);
  
  //Write Random EEPROM Serial if Not Set in Byte 0
  if(int(EEPROM.read(0)) != 111){
    Serial.println("Serial not set....");
    for (int i=1; i<5; i++){
      EEPROM.write(i, random(255));
    }
    EEPROM.write(0,111);
  }else{
    Serial.print("Serial set...");
  }
  
  //Read EEPROM Serial in Bytes 1-4 (0 contains isset)
  for (int i=1; i<5; i++){
    int ee_val = EEPROM.read(i);
    //Read Serial into String, format 001
    if(ee_val < 100){
      ee_serial += 0;
    }
    if(ee_val < 10){
      ee_serial += 0;
    }
    ee_serial += ee_val;
  }
  
  Serial.print(ee_serial);
  Serial.println();
  
  //Time TEMPORARY
  time_t myTime = millis();
  
  //SD IO
  pinMode(cardDetect, INPUT);
  pinMode(chipSelect, OUTPUT);
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(10, OUTPUT);
}

void loop(){
  // See if Card is Present
  if (!digitalRead(cardDetect)) {

    // Attempt to initialize card
    if (!card.init(SPI_HALF_SPEED, chipSelect)) {
      Serial.println("ERRROR : Card Failed to Initialize.");
      while(1){
      }
    } 
    else if (!cardInit) {
      Serial.println("Card Initialized.");
      cardInit = true;
    }
    
    // initialize a FAT volume
  if (!volume.init(card)) Serial.println("volume.init");
  
  // open the root directory
  if (!root.openRoot(volume)) Serial.println("openRoot");
  
    //Grab Data
    String dataString = "";
    
    dataString += "Temp: ";
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
  
   //Open or Create todays log file
     //If Create, print header in logfile CSV
   //Write Sensor Values
   //Close File
  }
  else{
    cardInit = false;
  }
  
  delay(logDelay);
}




