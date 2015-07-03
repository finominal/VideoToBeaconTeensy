
int numLeds = 51; 
byte[] pixelBuffer;
int w = 640;
int h = 360;
int widthFactor, heightFactor;

LED[] leds = new LED[numLeds]; //have to know num leds


class LED
{
  int x,y;
  
   LED(int _x, int _y)
  {
    x=_x;
    y=_y;
  }
}



void PopulateLedArray()
{
leds[0] = new LED(2,0);
leds[1] = new LED(2,1);
leds[2] = new LED(2,2);
leds[3] = new LED(2,3);
leds[4] = new LED(2,4);
leds[5] = new LED(2,5);
leds[6] = new LED(2,6);
leds[7] = new LED(2,7);
leds[8] = new LED(2,8);
leds[9] = new LED(2,9);
leds[10] = new LED(2,10);
leds[11] = new LED(2,11);
leds[12] = new LED(2,12);
leds[13] = new LED(2,13);
leds[14] = new LED(2,14);
leds[15] = new LED(2,15);
leds[16] = new LED(2,16);
leds[17] = new LED(2,17);
leds[18] = new LED(2,18);
leds[19] = new LED(2,19);
leds[20] = new LED(2,20);
leds[21] = new LED(2,21);
leds[22] = new LED(2,22);
leds[23] = new LED(2,23);
leds[24] = new LED(2,24);
leds[25] = new LED(2,25);
leds[26] = new LED(2,26);
leds[27] = new LED(2,27);
leds[28] = new LED(2,28);
leds[29] = new LED(2,29);
leds[30] = new LED(2,30);
leds[31] = new LED(2,31);
leds[32] = new LED(2,32);
leds[33] = new LED(2,33);
leds[34] = new LED(2,34);
leds[35] = new LED(2,35);
leds[36] = new LED(2,36);
leds[37] = new LED(2,37);
leds[38] = new LED(2,38);
leds[39] = new LED(2,39);
leds[40] = new LED(2,40);
leds[41] = new LED(2,41);
leds[42] = new LED(2,42);
leds[43] = new LED(2,43);
leds[44] = new LED(2,44);
leds[45] = new LED(2,45);
leds[46] = new LED(2,46);
leds[47] = new LED(2,47);
leds[48] = new LED(2,48);
leds[49] = new LED(2,49);
leds[50] = new LED(2,50);
}

