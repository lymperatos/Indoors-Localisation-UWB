

void track(){
  float ax =  anchors.get(0).x;
   float bx =  anchors.get(1).x;
    float cx =  anchors.get(2).x;
  float ay =  anchors.get(0).y;
   float by =  anchors.get(1).y;
    float cy =  anchors.get(2).y;
    int i = 130;
  float d1 =  anchors.get(0).dist*i;
   float d2 =  anchors.get(1).dist*i;
    float d3 =  anchors.get(2).dist*i;
    
   float a = 2*bx - 2*ax;
   float b = 2*by - 2*ay;
   float c = pow(d1, 2) - pow(d2, 2) - pow(ax, 2) + pow(bx, 2) - pow(ay, 2) + pow(by, 2);
   float d = 2*cx - 2*bx;
   float e = 2*cy - 2*by;
   float f = pow(d2, 2) - pow(d3, 2) - pow(bx, 2) + pow(cx, 2) - pow(by, 2) + pow(cy, 2);
   
   float x = (c*e - f*b)/(e*a - b*d);
   float y = (c*d - a*f)/(b*d - a*e);              
   noStroke();
       fill(255);
      ellipse(x,y,5,5);
   noFill();
   stroke(tagColor);
   
   tx = x;
   ty = y;
   //ellipse(x,y,10,10);
   
  /*
   line(x,y-10,x,y-30);
    line(x,y+10,x,y+30);
     line(x+10,y,x+30,y);
      line(x-10,y,x-30,y);
      */
              //rect( x-5, y-5, 10, 10);
              //line(x,y+30,x,y-30);
              //line(x+30,y,x-30,y);
 
     stroke(255,0,0);
     strokeWeight(1.5);
     arc(x, y, 20, 20, degrees(x/500)-HALF_PI, degrees(x/500));
     arc(x, y, 35, 35, -degrees(y/700)-PI, -degrees(y/700));
     
              
  //println(x,y);
   stroke(255);
}