#include <Arduino.h>
#include <WS2812Serial.h>

const int numled = 17;
const int pin = 14;
//  Usable pins:
//   Teensy 4.0:  1, 8, 14, 17, 20, 24, 29, 39
byte drawingMemory[numled*4];         //  4 bytes per LED for RGBW
DMAMEM byte displayMemory[numled*16]; // 16 bytes per LED for RGBW

WS2812Serial leds(numled, displayMemory, drawingMemory, pin, WS2812_GRB);

extern "C" int main(void) {
  leds.begin();

  const int colors[] = { 0xff0000, 0xff00ff, 0x00ff00, 0x0000ff };
  for (auto i = 0; i < leds.numPixels(); ++i) {
    leds.setPixelColor(i, colors[i % 4]);
  }

  int currentBrightness = 255;
  while (true) {
    if (currentBrightness > 0) {
      currentBrightness = currentBrightness - 1;
    } else {
      currentBrightness = 255;
    }
    leds.setBrightness(currentBrightness);
    leds.show();
    delayMicroseconds(5000);
  }
}

