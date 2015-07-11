
/**
 * Frames 
 * by Andres Colubri. 
 * 
 * Moves through the video one frame at the time by using the
 * arrow keys. It estimates the frame counts using the framerate
 * of the movie file, so it might not be exact in some cases.
 */
 
import processing.video.*;
PrintWriter output;

String fileName = dataPath("/users/finbot/desktop/Firescarf.txt");

int brightnessDividor = 2; //pitch down the brightness, more is duller
boolean colorSmoothing = false;
boolean dev = false;

Movie mov;
int newFrame = 0;
int movFrameRate = 25;//need to match video
int famesToCapture;

void setup() {
  size(640, 360);
  background(0);
  // Load and set the video to play. Setting the video 
  // in play mode is needed so at least one frame is read
  // and we can get duration, size and other information from
  // the video stream. 
  mov = new Movie(this, "/Users/finbot/Documents/Projects/VestVideos/Firelooped.mp4");
  //mov = new Movie(this, "/Users/finbot/Documents/Projects/Animation Videos/Artcar Videos/FireColorGraded.mp4");
  
  // Pausing the video at the first frame. 
  mov.play();
  mov.jump(0);
  mov.pause();
  
  //famesToCapture = getLength();
  famesToCapture = 350;
  SetupLedRendering();
  
}

void SetupLedRendering()
{
  PopulateLedArray();
  StretchToFrameFactoring();
  
  //create a buffer the length of the video;
  pixelBuffer = new byte[numLeds*3*famesToCapture];

}

void draw() {
  background(0);
  fill(255);
  setFrame(newFrame);  
  image(mov, 0, 0, width, height);
  
  //main action
  GetPixelDataFromFrame();
  
  //Finished getting all the frames, now write to file
  if(newFrame==famesToCapture-1)
  {
    DeletePreviousFile();
    //saveBytes(fileName, pixelBuffer);
    RenderAsTextArray();
    println("Processing Completed");
    exit();
  }
  else //not finished, get the next frame
  {
    newFrame++;
  }
  
  //show progress on the screen
  text(newFrame + " / " + (famesToCapture - 1), 10, 30);
}

//get the actual frame/image from the video
int getFrame() {    
  return ceil(mov.time() * 30) - 1;
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
    
    widthFactor = width/maxX;
    heightFactor = height/maxY;
  

    print(" widthFactor="); println(widthFactor);
    print(" heightFactor="); println(heightFactor);
}


void movieEvent(Movie m) {
  m.read();
}


//Move location to a particular frame. Bit crude in implementation
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
    
    LED pixel = new LED(leds[i].x+2, leds[i].y+5); //plus 2 is to offset from the boarder
    
    //stretch the pixel to get to spread the XY of the array over the whole video
    //pixel.x *= widthFactor; 
    pixel.y *= heightFactor; 
    
    loadPixels();
    color c = get(width - 300, height - pixel.y);
    //print(" c=");println(c);
    
    b = c&0x000000ff;
    c>>=8;
    g = c&0x000000ff; 
    c>>=8;
    r = c&0x000000ff;
    
    //This might help make it look smothers
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
      print(" c=");print(c);
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
    //del(10);
  }
}





//HELPERS
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (0 < newFrame) newFrame--; 
    } else if (keyCode == RIGHT) {
      if (newFrame < famesToCapture - 1) newFrame++;
    }
  } 
  setFrame(newFrame);  
  GetPixelDataFromFrame();
}
  


void del(int wait)
{
  long start = millis();
  while(start+wait>millis()){}
}
