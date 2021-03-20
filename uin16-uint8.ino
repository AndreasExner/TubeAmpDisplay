
const uint16_t in[100] =
{
0x0000, 0x0000, 0x0000, 0x1000, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x2000, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x1800, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0800, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0800, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0800, 0xf800, 0xf800, 0x0800, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x1000, 0xf800, 0xf800, 0x0800, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0000, 0xf800, 0xf800, 0x0000, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0000, 0xf800, 0xf800, 0x0800, 0x0000, 0x0000, 0x0000, 
0x0000, 0x0000, 0x0000, 0x0000, 0xf800, 0xf800, 0x0800, 0x0000, 0x0000, 0x0000
};


void setup() {

  Serial.begin(115200);  
  delay(1000);

  Serial.println("\n\nbyte by byte:");
  byteByByte();

  Serial.println("\n\nreinterpret_cast:");
  reintCast();
}

void byteByByte() {
  
  int perLine = 20;
  int counter = 0;
  uint8_t out;

  int len = sizeof(in) / sizeof(in[0]);
  
  for (int i = 0; i < len; i++)
  {
    out = in[i] >> 8;
    Serial.print("0x");
    Serial.print(nibble_to_hex(out >> 4));
    Serial.print(nibble_to_hex(out));
    Serial.print(", ");
    counter++;

    out = in[i];
    Serial.print("0x");
    Serial.print(nibble_to_hex(out>>4));
    Serial.print(nibble_to_hex(out));
    if (i < len - 1) {Serial.print(", ");}
    counter++;
 
    if (counter >= perLine) {
      Serial.print("\n");
      counter = 0;
    }
  }
}

void reintCast() {

  int perLine = 20;
  int counter = 0;

  const uint8_t *out; 
  out = reinterpret_cast<const uint8_t *>(in);

  int len = sizeof(in) / sizeof(in[0]) * 2;

  for (int i = 0; i < len; i++)
  {
    Serial.print("0x");
    Serial.print(nibble_to_hex(out[i] >> 4));
    Serial.print(nibble_to_hex(out[i]));

    if (i < len - 1) {Serial.print(", ");}
    counter++;
 
    if (counter >= perLine) {
      Serial.print("\n");
      counter = 0;
    }
  }
}


char nibble_to_hex(uint8_t nibble) {
  nibble &= 0xF;
  return nibble > 9 ? nibble - 10 + 'A' : nibble + '0';
}

void loop() {

  delay(1000);

}
