#include <Arduino.h>
#include <DW1000Ng.hpp>
#include <DW1000NgUtils.hpp>
#include <DW1000NgTime.hpp>
#include <DW1000NgConstants.hpp>
#include <DW1000NgRanging.hpp>
#include <DW1000NgRTLS.hpp>


const uint8_t PIN_RST = 15; // reset pin
const uint8_t PIN_SS = 2; // spi select pin

char EUI[] = "AA:BB:CC:DD:EE:FF:00:00";


device_configuration_t DEFAULT_CONFIG = {
  false,
  true, 
  true,
  true,
  false,
  SFDMode::STANDARD_SFD,
  Channel::CHANNEL_4,
  DataRate::RATE_850KBPS,
  PulseFrequency::FREQ_64MHZ,
  PreambleLength::LEN_256,
  PreambleCode::CODE_17
};

frame_filtering_configuration_t TAG_FRAME_FILTER_CONFIG = {
    false,
    false,
    true,//
    false,
    false,
    false,
    false,
    false
};


void setup() {

    Serial.begin(115200);
    Serial.println(F("===== TAG ====="));

    DW1000Ng::initializeNoInterrupt(PIN_SS, PIN_RST);

    Serial.println("> Initialized...");
    DW1000Ng::applyConfiguration(DEFAULT_CONFIG);
    DW1000Ng::enableFrameFiltering(TAG_FRAME_FILTER_CONFIG);

    DW1000Ng::setEUI(EUI);

    DW1000Ng::setNetworkId(RTLS_APP_ID);

    DW1000Ng::setAntennaDelay(16436);


    DW1000Ng::setPreambleDetectionTimeout(15);
    DW1000Ng::setSfdDetectionTimeout(273);
    DW1000Ng::setReceiveFrameWaitTimeoutPeriod(2000);

    DW1000Ng::enableDebounceClock();
    DW1000Ng::enableLedBlinking();
    DW1000Ng::setGPIOMode(6, LED_MODE);
    DW1000Ng::setGPIOMode(10, LED_MODE);
    DW1000Ng::setGPIOMode(12, LED_MODE);

    char msg[128];
    DW1000Ng::getPrintableDeviceIdentifier(msg);
    Serial.print("Device ID: "); Serial.println(msg);
    DW1000Ng::getPrintableExtendedUniqueIdentifier(msg);
    Serial.print("Unique ID: "); Serial.println(msg);
    DW1000Ng::getPrintableNetworkIdAndShortAddress(msg);
    Serial.print("Network ID & Device Address: "); Serial.println(msg);
    DW1000Ng::getPrintableDeviceMode(msg);
    Serial.print("Device mode: "); Serial.println(msg);
}

void loop() {

    DW1000Ng::setEUI(EUI);
    RangeInfrastructureResult res = DW1000NgRTLS::tagTwrLocalize(1500);


}
