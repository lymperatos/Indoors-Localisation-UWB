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

const int tLed = 14;


const int a1 = 6018; 
const int a2 = 6019; 
const int a3 = 6020; 
const int a4 = 6021; 

float d1,d2,d3,d4 = 0;



typedef union {
 float floatingPoint;
 byte binary[4];
 unsigned long ulong;
} binaryFloat;


void printFloat(float v){
  binaryFloat b;
  b.floatingPoint = v;  
  Serial.write(b.binary[0]);  
  Serial.write(b.binary[1]);  
  Serial.write(b.binary[2]);  
  Serial.write(b.binary[3]);  
}

void printLong(unsigned long v){
  binaryFloat b;
  b.ulong = v; 
  Serial.write(b.binary[0]);  
  Serial.write(b.binary[1]);  
  Serial.write(b.binary[2]);  
  Serial.write(b.binary[3]);  
}

void showDeviceInfo(){
    // DEBUG chip info and registers pretty printed
    char msg[256];
    DW1000.getPrintableDeviceIdentifier(msg);
    Serial.print("Device ID: "); Serial.println(msg);
    DW1000.getPrintableExtendedUniqueIdentifier(msg);
    Serial.print("Unique ID: "); Serial.println(msg);
    DW1000.getPrintableNetworkIdAndShortAddress(msg);
    Serial.print("Network ID & Device Address: "); Serial.println(msg);
    DW1000.getPrintableDeviceMode(msg); 
    Serial.print("Device mode: "); Serial.println(msg);
}


/* Wifi setup */
//#define WIFI_SSID "****";
//#define WIFI_PASSWORD "****";

/* Firebase Setup */
//#define databaseURL "https://****.com";
//#define secret "****";
FirebaseData firebaseData;
String folder = "/users/eEPjvQNNSvQODEAwq31YdRrRvCi2/";

TaskHandle_t Task1;


void setup() {
  Serial.begin(115200);
  delay(1000);
 
  startDWM1000();   /* DW1000 Connection */
  startWifi();      /* Wifi connection */
  startFirebase();  /* Firebase connection */ 

  pinMode(tLed, OUTPUT);
  digitalWrite(tLed, LOW);


//  xTaskCreatePinnedToCore(
//                    Task1code,   /* Task function. */
//                    "DW loop",     /* name of task. */
//                    10000,       /* Stack size of task */
//                    NULL,        /* parameter of the task */
//                    1,           /* priority of the task */
//                    &Task1,      /* Task handle to keep track of created task */
//                    0);          /* pin task to core 0 */                  
//  delay(500); 

//   xTaskCreatePinnedToCore(
//                    Task2code,   /* Task function. */
//                    "Uploading to firebase",     /* name of task. */
//                    10000,       /* Stack size of task */
//                    NULL,        /* parameter of the task */
//                    1,           /* priority of the task */
//                    &Task1,      /* Task handle to keep track of created task */
//                    1);          /* pin task to core 0 */     

}

/* Core 0 loop */
int period = 1000;
unsigned long time_now = 0;

//void Task1code( void * pvParameters ){
// digitalWrite(tLed, HIGH);
//  Serial.println(xPortGetCoreID());
// for(;;){
//       
//
//    
//    delay(30);
//    
//         
// }
//    
//}




/* Core 0 loop*/
//void loop0(){
//
//  Firebase.setFloat(firebaseData, folder+"Devices/Anchor 1/dist", d1);
//  Firebase.setFloat(firebaseData, folder+"Devices/Anchor 2/dist", d2);
// 
//  //Firebase.setFloat(firebaseData, folder+"Devices/Anchor 3/dist", d3);
//  
//}
/* Core 1 loop*/
void loop() {
    
  
    DW1000Ranging.loop();

     if(millis() >= time_now + period){
        time_now += period;
           Firebase.setFloat(firebaseData, folder+"Devices/Anchor 1/dist", d1);
    Firebase.setFloat(firebaseData, folder+"Devices/Anchor 2/dist", d2);
    }
 
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

void startDWM1000(){
  DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); //Reset, CS, IRQ pin
  DW1000Ranging.attachNewRange(newRange);
 // DW1000Ranging.attachNewDevice(newDevice);
  //DW1000Ranging.attachInactiveDevice(inactiveDevice);
  //DW1000Ranging.useRangeFilter(false);
//
//  DW1000.enableDebounceClock();
//  DW1000.enableLedBlinking();
//
//  DW1000.setGPIOMode(MSGP0, LED_MODE);
//  DW1000.setGPIOMode(MSGP2, LED_MODE);
//  DW1000.setGPIOMode(MSGP3, LED_MODE);


  DW1000Ranging.startAsTag("00:00:22:EA:82:60:3B:9C", DW1000.MODE_LONGDATA_RANGE_ACCURACY);
}

void startFirebase(){
  Firebase.begin(databaseURL, secret);
}

//void newRange() {
//  if(DW1000Ranging.getDistantDevice()->getShortAddress() == a1){
//  d1 = DW1000Ranging.getDistantDevice()->getRange();
//  if(d1 >= 0.01){
//  Firebase.setFloat(firebaseData, folder+"Devices/Anchor 1/dist", d1);
//  }
//  }else{
//     d1 = DW1000Ranging.getDistantDevice()->getRange();
//    Firebase.setFloat(firebaseData, folder+"Devices/Anchor 2/dist", d1);
//  }
//}

float dist,power = 0;
void newRange(){ 
  float d = DW1000Ranging.getDistantDevice()->getRange();
  float p = DW1000Ranging.getDistantDevice()->getRXPower();
  unsigned int a = DW1000Ranging.getDistantDevice()->getShortAddress();

//  int idx = (a >> 8) - 49;
//  if (idx == 0) d1 = d;
//  if (idx == 1) d2 = d;
//  Serial.print(d1);
//  Serial.print("  ");
//  Serial.println(d2);
  
//  Serial.write(0x44);
//  Serial.write(0xaa); 
//  printLong(millis());
//  Serial.write(a >> 8);
//  Serial.write(a & 0xFF);
//  printFloat(d);
//  printFloat(p);  
//  Serial.write(0x44);
//  Serial.write(0xaa);  
  if(DW1000Ranging.getDistantDevice()->getShortAddress() == a1){
  Serial.print("from: "); Serial.print(DW1000Ranging.getDistantDevice()->getShortAddress(), HEX);  
  Serial.print("\t Range: "); Serial.print(DW1000Ranging.getDistantDevice()->getRange()); Serial.print(" m"); 
  Serial.print("\t RX power: "); Serial.print(DW1000Ranging.getDistantDevice()->getRXPower()); Serial.println(" dBm");
 d1= DW1000Ranging.getDistantDevice()->getRange();
  }else{
    Serial.print("from: "); Serial.print(DW1000Ranging.getDistantDevice()->getShortAddress(), HEX);  
  Serial.print("\t Range: "); Serial.print(DW1000Ranging.getDistantDevice()->getRange()); Serial.print(" m"); 
  Serial.print("\t RX power: "); Serial.print(DW1000Ranging.getDistantDevice()->getRXPower()); Serial.println(" dBm");
  d2= DW1000Ranging.getDistantDevice()->getRange();
  }
//  
//  dist = 0.9 * dist + 0.1 * d;
//  power = 0.9* power + 0.1 * p;
//  Serial.print("NAme: ");
//  Serial.print(a);
//  Serial.print("distance: ");
//  Serial.print(dist);
//  Serial.print(" m");
//  Serial.print("  power: ");
//  Serial.print(power);
//  Serial.println(" dBm");
}

void newDevice(DW1000Device* device) {
  Serial.print("ranging init; 1 device added ! -> ");
  Serial.print(" short:");
  Serial.println(device->getShortAddress(), HEX);
}

void inactiveDevice(DW1000Device* device) {
  Serial.print("delete inactive device: ");
  Serial.println(device->getShortAddress(), HEX);
}
