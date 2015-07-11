


void RenderAsTextArray()
{
  int loc = 0;
  output = createWriter(fileName);
  output.print("//LED COUNT: "); output.println(numLeds);
  output.print("int numberOfFrames = "); output.print(famesToCapture); output.println(";");  ///bike beacon
  output.print("FLASH_TABLE( char, fireFrames ,"); output.print(numLeds*3); ;output.println(","); 
  
  //Save The Data as a text array so it can be copied into Arduino
  for(int i = 0; i<famesToCapture; i++)//for each frame
  //for(int i = 0; i<10; i++)//for each frame
  {
    
    //println(loc);
    output.print("{");
      for(int j = 0; j<3*numLeds; j++)//for each pixel
      {
        output.print(pixelBuffer[loc]);
        if(j<3*numLeds-1) output.print(",");
        
        loc++;
      }
  output.println("},");
}

output.flush();
output.close();
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
