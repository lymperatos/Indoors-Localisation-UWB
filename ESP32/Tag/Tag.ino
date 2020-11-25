#include <SPI.h>
#include "DW1000Ranging.h"
#include <WiFi.h>
#include "FirebaseESP32.h"
#include "credentials.h"

/* Pins connecting DWM1000 */
const uint8_t PIN_SCK = 18;
const uint8_t PIN_MOSI = 23;
const uint8_t PIN_MISO = 19;
const uint8_t PIN_SS = 2;
const uint8_t PIN_RST = 15;
const uint8_t PIN_IRQ = 17;

/* Wifi setup */
//#define WIFI_SSID "****";
//#define WIFI_PASSWORD "****";

/* Firebase Setup */
//#define databaseURL "https://****.com";
//#define secret "****";
FirebaseData firebaseData;
String folder = "/Tag";

TaskHandle_t Task1;
float prev = 0.0;

void setup() {
  Serial.begin(115200);
  delay(1000);
 
  startDWM1000();   /* DW1000 Connection */
  startWifi();      /* Wifi connection */
  startFirebase();  /* Firebase connection */ 


  xTaskCreatePinnedToCore(
                    Task1code,   /* Task function. */
                    "Task1",     /* name of task. */
                    10000,       /* Stack size of task */
                    NULL,        /* parameter of the task */
                    1,           /* priority of the task */
                    &Task1,      /* Task handle to keep track of created task */
                    0);          /* pin task to core 0 */                  
  delay(500); 

}
 
/* Core 0 loop */
void Task1code( void * pvParameters ){
    for(;;){
      loop0();
    } 
}

/* Core 0 loop*/
void loop0(){
  Firebase.setFloat(firebaseData, folder+"/A1", prev);
    delay(1000);
}
/* Core 1 loop*/
void loop() {
  DW1000Ranging.loop();
}


void startWifi(){
   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println("");
}

void startDWM1000{
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); //Reset, CS, IRQ pin
  DW1000Ranging.attachNewRange(newRange);
  DW1000Ranging.attachNewDevice(newDevice);
  DW1000Ranging.attachInactiveDevice(inactiveDevice);
  DW1000Ranging.useRangeFilter(true);

  DW1000.enableDebounceClock();
  DW1000.enableLedBlinking();

  DW1000.setGPIOMode(MSGP0, LED_MODE);
  DW1000.setGPIOMode(MSGP2, LED_MODE);
  DW1000.setGPIOMode(MSGP3, LED_MODE);


  DW1000Ranging.startAsTag("7D:00:22:EA:82:60:3B:9C", DW1000.MODE_LONGDATA_RANGE_ACCURACY);
}

void startFirebase(){
  Firebase.begin(databaseURL, secret);
}

void newRange() {
 // Serial.print("from: "); Serial.print(DW1000Ranging.getDistantDevice()->getShortAddress(), HEX);
  Serial.print("\t Range: ");
  Serial.println(DW1000Ranging.getDistantDevice()->getRange()); //Serial.print(" m");
  //Serial.print("\t RX power: "); Serial.print(DW1000Ranging.getDistantDevice()->getRXPower()); Serial.println(" dBm");
  
  if(DW1000Ranging.getDistantDevice()->getRange() != prev){
    prev = DW1000Ranging.getDistantDevice()->getRange();
    
  }
  
}

void newDevice(DW1000Device* device) {
  Serial.print("ranging init; 1 device added ! -> ");
  Serial.print(" short:");
  //Serial.println(device->getShortAddress(), HEX);
}

void inactiveDevice(DW1000Device* device) {
  Serial.print("delete inactive device: ");
 // Serial.println(device->getShortAddress(), HEX);
}
