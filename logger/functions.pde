void sd_card_pinMode_set(){
  pinMode(cardDetect, INPUT);
  pinMode(chipSelect, OUTPUT);
  /* make sure that the default chip select pin is set to
  output, even if you don't use it:*/
  pinMode(10, OUTPUT);
}

boolean sd_card_present(){
  return !digitalRead(cardDetect);
}

boolean try_initialize_card(){
    if (!card.init(SPI_HALF_SPEED, chipSelect)) {
      Serial.println("ERRROR : Card Failed to Initialize.");
      return false;
      //Visual Error Message
    } 
    else if (!cardInit) {
      Serial.println("Card Initialized.");
      cardInit = true;
    }
}

