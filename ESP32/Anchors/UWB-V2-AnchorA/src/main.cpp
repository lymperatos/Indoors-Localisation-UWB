#include <Arduino.h>
#include <DW1000Ng.hpp>
#include <DW1000NgUtils.hpp>
#include <DW1000NgRanging.hpp>
#include <DW1000NgRTLS.hpp>
#include <WiFi.h>
//#include "credentials.h"

//#define WIFI_SSID "******" // Your wifi name
//#define WIFI_PASSWORD "******" // Your wifi Password

const uint8_t PIN_RST = 15; // reset pin
const uint8_t PIN_SS = 2; // spi select pin

//EUI For each Acnhor

char EUI1[] = "AA:BB:CC:DD:EE:FF:00:01"; //A
char EUI2[] = "AA:BB:CC:DD:EE:FF:00:02"; //B
char EUI3[] = "AA:BB:CC:DD:EE:FF:00:03"; //C

int id = 3; // Change this to set up each uniqe anchor.
float range_self = 0;

byte tag_shortAddress[] = {0x05, 0x00};

device_configuration_t DEFAULT_CONFIG = {
  false,
  true, //
  true,//
  true,
  false,
  SFDMode::STANDARD_SFD,
  Channel::CHANNEL_4,
  DataRate::RATE_850KBPS,
  PulseFrequency::FREQ_64MHZ,
  PreambleLength::LEN_256,
  PreambleCode::CODE_17
};

frame_filtering_configuration_t ANCHOR_FRAME_FILTER_CONFIG = {
    false,
    false,
    true,
    false,
    false,
    false,
    false,
    true
};
//UDP server
WiFiUDP Udp;
IPAddress remoteIP(192,168,3,4); //IP of the computer running the Processing Application
unsigned int remotePort = 5005; //Port

// Starting WIFI
void startWifi(){
   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while(WiFi.status() != WL_CONNECTED){
    //Serial.print(".");
    //digitalWrite(tLed, HIGH);
    //delay(300);
    //digitalWrite(tLed, LOW);
  }
  //Serial.println("");
}
float prevRange = 0;
void setup() {
    Serial.begin(115200);
    startWifi();
    DW1000Ng::initializeNoInterrupt(PIN_SS, PIN_RST);
    DW1000Ng::applyConfiguration(DEFAULT_CONFIG);
    DW1000Ng::enableFrameFiltering(ANCHOR_FRAME_FILTER_CONFIG);

    switch (id)
    {
    case 1:
        Serial.println(F("===== ANCHOR 1 ====="));
         DW1000Ng::setEUI(EUI1);
        break;
    case 2:
        Serial.println(F("===== ANCHOR 2 ====="));
         DW1000Ng::setEUI(EUI2);
        break;
    case 3:
        Serial.println(F("===== ANCHOR 3 ====="));
         DW1000Ng::setEUI(EUI3);
        break;

    default:
        Serial.println(F("[X] ID Should be 1 ,2 ,3!"));
        break;
    }

    Serial.println(F("Initialized..."));

    DW1000Ng::setPreambleDetectionTimeout(64);
    DW1000Ng::setSfdDetectionTimeout(273);
    DW1000Ng::setReceiveFrameWaitTimeoutPeriod(2000);

    DW1000Ng::setNetworkId(RTLS_APP_ID);
    DW1000Ng::setDeviceAddress(id);
    DW1000Ng::setAntennaDelay(16436);

}

void loop() {


    if(DW1000NgRTLS::receiveFrame()){
        size_t recv_len = DW1000Ng::getReceivedDataLength();
        byte recv_data[recv_len];
        DW1000Ng::getReceivedData(recv_data, recv_len);


        if(recv_data[0] == BLINK) {
            DW1000NgRTLS::transmitRangingInitiation(&recv_data[2], tag_shortAddress);
            DW1000NgRTLS::waitForTransmission();

            RangeAcceptResult result = DW1000NgRTLS::anchorRangeAccept(NextActivity::RANGING_CONFIRM, 2);
            if(!result.success) return;

            range_self = result.range;
            String rangeString = "Range: "; rangeString += range_self; rangeString += " m";

           if(prevRange != range_self){
           Udp.beginPacket(remoteIP, remotePort);
           Udp.print(id); //
           Udp.print(":");
           Udp.print(range_self);
           Udp.endPacket();
           prevRange = range_self;
          }
            delay(30);
            Serial.println(rangeString);

        }
    }


}
