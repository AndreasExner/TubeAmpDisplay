/*

  Tube Amplifier Display

  Version: 0.1
  Date: 2021-03-13

  MIT License
  
  Copyright (c) 2020 Andreas Exner
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/


#include "lcdgfx.h"
#include "lcdgfx_gui.h"
#include "logo16.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 128

#define SCLK_PIN D5
#define MOSI_PIN D7
#define DC_PIN D3
#define CS_PIN D8
#define RST_PIN D0

#define BLACK 0x0000
#define BLUE 0x001F
#define RED 0xF800
#define GREEN 0x07E0
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define YELLOW 0xFFE0
#define WHITE 0xFFFF

DisplaySSD1351_128x128x16_SPI display(RST_PIN,{-1, CS_PIN, DC_PIN, 0,SCLK_PIN, MOSI_PIN}); // Use this line for ESP32 (VSPI)  (gpio22=RST, gpio5=CE for VSPI, gpio21=D/C



void setup(void) {

  Serial.begin(115200);  
  delay(1000);

  display.begin();
  display.getInterface().setRgbMode( 0 );
  display.fill(BLACK);

  DisplayLogo();
}

void DisplayLogo(void) {

  display.clear();
  display.drawBitmap16(16, 10, 101, 19, reinterpret_cast<const uint8_t *>(logo16));
}


void loop(void)
{
  delay(1000);
}
