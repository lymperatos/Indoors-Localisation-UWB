#include <SPI.h>
#include "DW1000Ranging.h"

#include <WiFi.h>
#include "FirebaseESP32.h"
#include "credentials.h"

const uint8_t PIN_SCK = 18;
const uint8_t PIN_MOSI = 23;
const uint8_t PIN_MISO = 19;
const uint8_t PIN_SS = 2;
const uint8_t PIN_RST = 15;
const uint8_t PIN_IRQ = 17;

const int tLed = 14;

FirebaseData firebaseData;
String folder = "/users/eEPjvQNNSvQODEAwq31YdRrRvCi2/";

void setup() {
  Serial.begin(115200);
  delay(1000);

    startWifi();      /* Wifi connection */
  startFirebase();  /* Firebase connection */ 
  
  //init the configuration
  DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); //Reset, CS, IRQ pin
  //define the sketch as anchor. It will be great to dynamically change the type of module
  DW1000Ranging.attachNewRange(newRange);
  DW1000Ranging.attachBlinkDevice(newBlink);
  DW1000Ranging.attachInactiveDevice(inactiveDevice);
  DW1000Ranging.useRangeFilter(false);

  
  DW1000.enableDebounceClock();
  DW1000.enableLedBlinking();

  DW1000.setGPIOMode(MSGP0, LED_MODE);
  DW1000.setGPIOMode(MSGP2, LED_MODE);
  DW1000.setGPIOMode(MSGP3, LED_MODE);

   pinMode(tLed, OUTPUT);
  
  //we start the module as an anchor
  DW1000Ranging.startAsAnchor("82:17:5B:D5:A9:9A:E2:9C", DW1000.MODE_LONGDATA_RANGE_ACCURACY);
  //DW1000Ranging.startAsAnchor("83:17:5B:D5:A9:9A:E2:9C", DW1000.MODE_LONGDATA_RANGE_ACCURACY);

 


}
int period = 5000;
unsigned long time_now = 0;
float d1 = 0;
void loop() {
  DW1000Ranging.loop();
//  digitalWrite(tLed, LOW);
//   if(millis() >= time_now + period){
//        time_now += period;
//        Serial.println("saved");
//      //  Firebase.setFloat(firebaseData, folder+"Devices/Anchor 1/dist", d1);
//    }
    
}

void newRange() {
   d1 = DW1000Ranging.getDistantDevice()->getRange();
 
  
}

void newBlink(DW1000Device* device) {
  Serial.print("blink; 1 device added ! -> ");
  Serial.print(" short:");
  Serial.println(device->getShortAddress(), HEX);
}

void inactiveDevice(DW1000Device* device) {
  Serial.print("delete inactive device: ");
  Serial.println(device->getShortAddress(), HEX);
}

void startWifi(){
   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    digitalWrite(tLed, HIGH);
    delay(300);
    digitalWrite(tLed, LOW);
  }
  Serial.println("");
}

void startFirebase(){
  Firebase.begin(databaseURL, secret);
}
