/**
 * Frames 
 * by Andres Colubri. 
 * 
 * Moves through the video one frame at the time by using the
 * arrow keys. It estimates the frame counts using the framerate
 * of the movie file, so it might not be exact in some cases.
 */
 
import processing.video.*;

String fileName = dataPath("/users/finbot/desktop/Fire1.led");

int brightnessDividor = 3; //pitch down the brightness, more is duller
boolean colorSmoothing = false;
boolean dev = true;

Movie mov;
int newFrame = 0;
int movFrameRate = 25;//need to match video

void setup() {
  size(640, 360);
  background(0);
  // Load and set the video to play. Setting the video 
  // in play mode is needed so at least one frame is read
  // and we can get duration, size and other information from
  // the video stream. 
  mov = new Movie(this, "/Users/finbot/Documents/Projects/VestVideos/Firelooped.mp4");
  
  // Pausing the video at the first frame. 
  mov.play();
  mov.jump(0);
  mov.pause();
  
  SetupLedRendering();
}

void SetupLedRendering()
{
  PopulateLedArray();
  StretchToFrameFactoring();
  
  //create a buffer the length of the video;
  pixelBuffer = new byte[numLeds*3*getLength()];

}

void StretchToFrameFactoring()
{
  int maxX = 0;
  int maxY = 0;
  for(int i = 0; i<numLeds; i++)
  {
    LED item = leds[i];
    if(item.x > maxX) maxX = item.x;
    if(item.y > maxY) maxY = item.y;
    }
    
    print(" maxX="); println(maxX);
    print(" maxY="); println(maxY);
    
    widthFactor = w/maxX;
    heightFactor = h/maxY;
  

    print(" widthFactor="); println(widthFactor);
    print(" heightFactor="); println(heightFactor);
}


void movieEvent(Movie m) {
  m.read();
}

void draw() {
  background(0);
  fill(255);
  setFrame(newFrame);  
  image(mov, 0, 0, width, height);
  
  GetPixelDataFromFrame();
  
  //if(newFrame==getLength()-1)
   if(newFrame==10)
  {
    DeletePreviousFile();
    saveBytes(fileName, pixelBuffer);
    RenderAsTextArray();
    println("Processing Completed");
    exit();
  }
  else
  {
    newFrame++;
  }
  
  //show progress on the screen
  text(newFrame + " / " + (getLength() - 1), 10, 30);
  //del(500);
}

void RenderAsTextArray()
{
  int loc = 0;
  
  //Save The Data as a text array so it can be copied into Arduino
  //for(int i = 0; i<getLength(); i++)//for each frame
  for(int i = 0; i<10; i++)//for each frame
  {
    println(loc);
    print("flame["); print(i); print("]{");
      for(int j = 0; j<3*numLeds; j++)//for each pixel
      {
        print(pixelBuffer[loc]);
        if(j<3*numLeds-1) print(",");
        
        loc++;
      }
  println("};");
}
}



void DeletePreviousFile()
{
  File f = new File(fileName);
  
  if (f.exists()) 
  {
    f.delete();
    println("Deleted Previous File");
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (0 < newFrame) newFrame--; 
    } else if (keyCode == RIGHT) {
      if (newFrame < getLength() - 1) newFrame++;
    }
  } 
  setFrame(newFrame);  
  GetPixelDataFromFrame();
}
  
int getFrame() {    
  return ceil(mov.time() * 30) - 1;
}

void setFrame(int n) {
  mov.play();
    
  // The duration of a single frame:
  float frameDuration = 1.0 / movFrameRate;
    
  // We move to the middle of the frame by adding 0.5:
  float where = (n * frameDuration)+  frameDuration/2; 
    
//  // Taking into account border effects:
//  float diff = mov.duration() - where;
//  if (diff < 0) {
//    where += diff - 0.25 * frameDuration;
//  }
    
  mov.jump(where);
  mov.pause();  
}  

int getLength() {
  return int(mov.duration() * movFrameRate); ///deems a bit unreliable
}  


void GetPixelDataFromFrame()
{
  for(int i = 0; i<numLeds; i++)//traverse all LEDS, and get the color from the matching location on the video file. 
  {
    //get color, and split
    int r,g,b, rr, gg, bb;
    r = b = g = rr = gg = bb = 0;
    
    LED pixel = new LED(leds[i].x+2, leds[i].y+2); //plus 2 is to offset from the boarder
    
    //stretch the pixel to get to spread the XY of the array over the whole video
    pixel.x *= widthFactor; 
    pixel.y *= heightFactor; 
    
    int c = get(width - pixel.x, height - pixel.y);
    print(" c=");println(c);
    
    b = c&0x000000ff;
    c>>=8;
    g = c&0x000000ff; 
    c>>=8;
    r = c&0x000000ff;
    
    if(colorSmoothing)
    {
      color cc = get((width - pixel.x)+1, (height - pixel.y)+1);
      bb = cc&0x000000ff;
      cc>>=8;
      gg = cc&0x000000ff; 
      cc>>=8;
      rr = cc&0x000000ff;
      
      r/=2;
      g/=2;
      b/=2;
      
      rr/=2;
      gg/=2;
      bb/=2;
      
    }
    
    int loc = newFrame*numLeds*3;
    pixelBuffer[loc+(i*3)] = (byte)((r+rr)/brightnessDividor);
    pixelBuffer[loc+(i*3+1)] = (byte)((g+gg)/brightnessDividor);
    pixelBuffer[loc+(i*3+2)] = (byte)((b+bb)/brightnessDividor);
    
    if(dev && i==10)
    {
      print(" fr="); print(newFrame);
      print(" px="); print(i);
      print(" c=");println(c);
      print(" r=");print(r);
      print(" g=");print(g);
      print(" b=");print(b);
      print(" rr=");print(rr);
      print(" gg=");print(gg);
      print(" bb=");print(bb);
      print(" sdr=");print(pixelBuffer[loc+i*3]);
      print(" sdg=");print(pixelBuffer[loc+i*3+1]);
      print(" sdb=");println(pixelBuffer[loc+i*3+2]);
      
    }
    
  }
}


void del(int wait)
{
  long start = millis();
  while(start+wait>millis()){}
}
