int step = 30; // Grid size

//Tail
int tailSize = 255;
float[] tailX = new float[tailSize];
float[] tailY = new float[tailSize];
float r = 5;

PFont font;
void drawGUI(){
        //background(24, 26, 36, 100);
        background(primary);
        
        

       for(int c = 0; c < width/step; c++ ) {
         //stroke(255,255,255,20);
         stroke(secondary,150);
         line(c*step, 0, c*step, height);
         line(0, c*step, width, c*step);
       } 
     
      
      
  if(editing){
      edit();
      
  }else{
    cursor(ARROW);
  }


//Drawing Anchors
  if(drawing){
    addAnchor(ax,ay, 0);
    addAnchor(bx,by, 1);
    addAnchor(cx,cy, 2);
    drawing = false;
  }
  
    sideBar();
   drawRoom();
  drawTail();
  
}
int limit=500;
void sideBar(){
  
  
  
    // fill(0,0,0);
     //noStroke();
     //rect(0,0, 300, height);
     
     fill(primary,200);
     stroke(secondary);
     rect(10, 10,280,160);
     //--- Satus
     
     fill(255);
     textSize(32);
     text("UWB TRACKER",20, 50);
     textSize(22);
     text("STATUS",20, 50+26);
     if(!simulation){
     fill(0,255,0);
     text("ONLINE",100, 50+26);
     }else{
     fill(#EFBD1C);
     text("SIMULATING",100, 50+26);
     }
     fill(255);
     text("IP: "+ip,20, 50+26*3);
     text("PORT: "+port,20, 50+26*4);
     fill(255);
     //--- room
     
     fill(primary,200);
     stroke(secondary);
     rect(10, 160+20,280,100);
     
     fill(255);
     textSize(32);
     text("ROOM",20, 210);
     textSize(22);
     text("width: "+roomW+"m",20, 210+26);
     text("height: "+roomH+"m",20, 210+26*2);
     
     
     //Distance
     
     fill(primary,200);
     stroke(secondary);
     rect(10, 280+10,280,110);
     
     fill(255);
     textSize(32);
     text("DISTANCES",20, 300+20);
     
     noStroke();
     textSize(22);
     
     fill(anchorAColor);
     text("A",20, 340+10);
     if(d1*50<=230){
     rect(40, 340,d1*50,10);
     }else{
       rect(40, 340,200,10);
     }
     fill(anchorBColor);
     text("B",20, 360+10);
     if(d2*50<=230){
     rect(40, 360,d2*50,10);
     }else{
       rect(40, 360,200,10);
     }
     fill(anchorCColor);
     text("C",20, 380+10);
     if(d3*50<=230){
     rect(40, 380,d3*50,10);
     }else{
       rect(40, 380,200,10);
     }
     
     
     //Anchors
     fill(primary,200);
     stroke(secondary);
     rect(10, 410,280,410);
     
     fill(255);
     textSize(32);
     text("ANCHORS",20, 410+30);
    
    textSize(22);
    
    //Alpha
    
    fill(anchorAColor);
    text("Alpha",20, 470);
    fill(255,100);
    if(stateA){
      text("Online",20, 470+25);
      fill(0,255,0);
      noStroke();
      rect(100, 470+15,10,10);
    }else{
       text("Offline",20, 470+25);
       fill(255,0,0);
        noStroke();
        rect(110, 470+15,10,10);
    }

    
      
    noFill();
    stroke(255);
    //strokeWeight();
    ellipse(200,500,70,70);
    fill(255,100);
    text("Angle: "+  int(-degrees(thetaA)-90) +"°",20, 520);
    fill(#75FAD4);
    stroke(#75FAD4);
    ellipse(200,500,3,3);
    ellipse(200-sin(thetaA)*35, 500+cos(thetaA)*35,5,5);
    line(200-sin(thetaA)*10, 500+cos(thetaA)*10, 200-sin(thetaA)*35, 500+cos(thetaA)*35);
    noFill();
    ellipse(200,500,50,50);
    noStroke();
 
    
    //Bravo
    
     fill(anchorBColor);
    text("Bravo",20, 530+30);
    if(stateB){
       fill(255,100);
      text("Online",20, 560+20);
      fill(0,255,0);
      rect(100, 560+10,10,10);
    }else{
      fill(255,100);
      text("Offline",20, 560+20);
      fill(255,0,0);
      rect(110, 560+10,10,10);
    }
    
    
      noFill();
    stroke(255);
    //strokeWeight();
    ellipse(200,590,70,70);
    fill(255,100);
    text("Angle: "+  int(degrees(thetaB)-90) +"°",20, 605);
    fill(#75FAD4);
    stroke(#75FAD4);
    ellipse(200,590,3,3);
    ellipse(200-sin(thetaB)*35, 590+cos(thetaB)*35,5,5);
    line(200-sin(thetaB)*10, 590+cos(thetaB)*10, 200-sin(thetaB)*35, 590+cos(thetaB)*35);
    noFill();
    ellipse(200,590,50,50);
    noStroke();
    
    //Charlie
    
    fill(anchorCColor);
    text("Charlie",20, 640);
    if(stateC){
      fill(255,100);
      text("Online",20, 640+22);
      fill(0,255,0);
      rect(100, 640+12,10,10);
    }else{
      fill(255,100);
      text("Ofline",20, 640+22);
      fill(255,0,0);
      rect(110, 640+12,10,10);
    }
    
    
    noFill();
    stroke(255);
    //strokeWeight();
    ellipse(200,680,70,70);
    fill(255,100);
    text("Angle: "+  int(-degrees(thetaC)-90) +"°",20, 685);
    fill(#75FAD4);
    stroke(#75FAD4);
    ellipse(200,680,3,3);
    ellipse(200-sin(thetaC)*35, 680+cos(thetaC)*35,5,5);
    line(200-sin(thetaC)*10, 680+cos(thetaC)*10, 200-sin(thetaC)*35, 680+cos(thetaC)*35);
    noFill();
    ellipse(200,680,50,50);
    noStroke();
    
    
     if(filter_){
       fill(#75FAD4);
       text("Filter: Enabled",20, 780);
     }else{
       fill(secondary);
       text("Filter: Disabled",20, 780);
     }
     
  

    
  
    
    //Right Side
    if(logging){
      fill(#75FAD4);
      text("EXPORTING DATA",width-180, height-30);
      text(exportedCount,width-180, height-10);
    }else{
      fill(#75FAD4,150);
      text("NO ACTIVITY",width-150, height-30);
    }
    
    
    //limit++;                        //Increments each frame
  if (limit > width) limit = 0;
    
      for(int i = 0; i < limit; i++)
    {
    float x = i*TAU/100;  
    float y = d1-i;
    point(i, y + height/2);      // Points for now
    }
     
}

void drawTail(){
  float[] tempX = new float[tailSize];
       float[] tempY = new float[tailSize];
       for(int i=0; i<tailSize-1; i++){
         tempX[i+1] = tailX[i];
         tempY[i+1] = tailY[i];
       }
       
       tempX[0] = tx;
       tempY[0] = ty;
       
       tailX = tempX;
       tailY = tempY;
       
       for(int i = 0; i<tailSize; i++){
            noStroke();
         //fill(0,255,0,255-255/tailSize*i*2);
         //ellipse(tailX[i], tailY[i], r, r);
         //stroke(255,0,0,255-255/tailSize*i*2);
         //line(tailX[i],tailY[i]+10,tailX[i],tailY[i]-10);
         //line(tailX[i]+10,tailY[i],tailX[i]-10,tailY[i]);
         //fill(255,0,0,255-255/tailSize*i*2);
         fill(tailColor,255-255/tailSize*i*2);
         ellipse(tailX[i], tailY[i], 2, 2);
       }
  
}