import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.net.*; 
import java.io.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class UWB_App extends PApplet {





DatagramSocket socket;
DatagramPacket packet;

byte[] buf = new byte[255]; //Set your buffer size as desired

public void setup() {
  
  background(255);
  PImage icon = loadImage("icon.png");
surface.setIcon(icon);
  try {
    socket = new DatagramSocket(5005); // Set your port here
  }
  catch (Exception e) {
    e.printStackTrace(); 
    println(e.getMessage());
  }
 
}
float r = 0;
float d1  = 2;
float d2  = 1;
float d3  = 1
;

float zoom = 250;



float tx,ty = 0;
public void draw() {
  background(255);
  noFill();
float ax = width/2+100;
float ay = 10-100;

float bx = width-100;
float by = height-10;

float cx = width/2;
float cy = height-10;
 
  r+=0.1f;
    ellipse(ax, ay, 10, 10); //Anchor 1
    ellipse(bx, by, 10, 10); //Anchor 2
     ellipse(cx, cy, 10, 10); //Anchor 2
    
     ellipse(ax, ay, zoom*d1, zoom*d1); //Anchor 1
      ellipse(bx, by, zoom*d2, zoom*d2); //Anchor 2
       ellipse(cx, cy, zoom*d3, zoom*d3); //Anchor 2
       
       track(ax,ay,d1, bx,by,d2, cx,cy,d3);
       
       
    
  
  try {
    DatagramPacket packet = new DatagramPacket(buf, buf.length);
    socket.receive(packet);
    InetAddress address = packet.getAddress();
    int port = packet.getPort();
    packet = new DatagramPacket(buf, buf.length, address, port);

    //Received as bytes:
    //println(Arrays.toString(buf));
    
    //If you wish to receive as String:
    String received = new String(packet.getData(), 0, packet.getLength());
    println(received);
    String[] sA = split(received,":");
    
     
     if(Integer.valueOf(sA[0]) == 1){
       print("1:");
       d1 = PApplet.parseFloat(trim(sA[1]));
       println(d1);
     }
     if(Integer.valueOf(sA[2]) == 2){
        print("2:");
        d2 = PApplet.parseFloat(trim(sA[3]));
        println(d2);
     }
     if(Integer.valueOf(sA[4]) == 3){
        print("3:");
        d3 = PApplet.parseFloat(trim(sA[5]));
        println(d3);
     }
  }
  catch (IOException e) {
    e.printStackTrace(); 
    //println(e.getMessage());
  }
  
}

public void track(float ax, float ay, float d1,float bx,float by,float d2,float cx,float cy,float d3){
   float a = 2*bx - 2*ax;
   float b = 2*by - 2*ay;
   float c = pow(d1, 2) - pow(d2, 2) - pow(ax, 2) + pow(bx, 2) - pow(ay, 2) + pow(by, 2);
   float d = 2*cx - 2*bx;
   float e = 2*cy - 2*by;
   float f = pow(d2, 2) - pow(d3, 2) - pow(bx, 2) + pow(cx, 2) - pow(by, 2) + pow(cy, 2);
   float x = (c*e - f*b)/(e*a - b*d);
   float y = (c*d - a*f)/(b*d - a*e);
   
   ellipse(x,y,10,10);
   println(x,y);
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "UWB_App" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
