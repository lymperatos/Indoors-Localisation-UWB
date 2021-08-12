/***
 *                                                                                        
 *                                                                                        
 *    UUUUUUUU     UUUUUUUUWWWWWWWW                           WWWWWWWWBBBBBBBBBBBBBBBBB   
 *    U::::::U     U::::::UW::::::W                           W::::::WB::::::::::::::::B  
 *    U::::::U     U::::::UW::::::W                           W::::::WB::::::BBBBBB:::::B 
 *    UU:::::U     U:::::UUW::::::W                           W::::::WBB:::::B     B:::::B
 *     U:::::U     U:::::U  W:::::W           WWWWW           W:::::W   B::::B     B:::::B
 *     U:::::D     D:::::U   W:::::W         W:::::W         W:::::W    B::::B     B:::::B
 *     U:::::D     D:::::U    W:::::W       W:::::::W       W:::::W     B::::BBBBBB:::::B 
 *     U:::::D     D:::::U     W:::::W     W:::::::::W     W:::::W      B:::::::::::::BB  
 *     U:::::D     D:::::U      W:::::W   W:::::W:::::W   W:::::W       B::::BBBBBB:::::B 
 *     U:::::D     D:::::U       W:::::W W:::::W W:::::W W:::::W        B::::B     B:::::B
 *     U:::::D     D:::::U        W:::::W:::::W   W:::::W:::::W         B::::B     B:::::B
 *     U::::::U   U::::::U         W:::::::::W     W:::::::::W          B::::B     B:::::B
 *     U:::::::UUU:::::::U          W:::::::W       W:::::::W         BB:::::BBBBBB::::::B
 *      UU:::::::::::::UU            W:::::W         W:::::W          B:::::::::::::::::B 
 *        UU:::::::::UU               W:::W           W:::W           B::::::::::::::::B  
 *          UUUUUUUUU                  WWW             WWW            BBBBBBBBBBBBBBBBB   
 *                                                                                        
 *   =============================================================================================
 *                                                                                        
 *   Title:  Ultra Wide Band Application                                                                               
 *   Author: Dimitris Lymperatos                                                                                     
 *   Date:   11 Apr 2021    
 *                                                                                        
 *   Description: This is an application which allows the viualisation of an Ultra Wide Band
 *                System. This software needs 3 Anchors and 1 Tag (using DWM1000 from Decawave
 *                on a custom PCB). Each anchor use an ESP32 to send UDP packets to this
 *                application of the Distance of each one.
 *
 *   =============================================================================================
 *                                                                                        
 */

import java.net.*;
import java.io.*;
import java.util.Arrays;
import processing.sound.*;
SoundFile S_ok;


void setup() {
  size(1400, 700,FX2D);
  background(primary);

  font = createFont("font.ttf", 64);
  textFont(font);
  //PImage icon = loadImage("icon.png");
  //surface.setIcon(icon);
  surface.setResizable(true);
  frameRate(120); 
  smooth(8); 
  readAnchors();
  setUpServer();
  setUpLog();
  S_ok = new SoundFile(this, "sounds/ok.wav");   

}


float tx,ty = 0; // Tag's X and Y.
float f = 0;

boolean drawing = true;
boolean filter_ = true;

//Room Dimensions in meters (Rectangular)
float roomW = 5.57;
float roomH = 8.63;

float zoom = 100;
float roomX = width/2-roomW*zoom;
float roomY = 100;

boolean nextData = true;
float ax = 0; //Green led
float ay = roomY + roomH*65;

float bx = 0;
float by = 20;

float cx = 0;
float cy = 20;

int filterValue = 15;

boolean simulation = true;
float simd1 =0;
float simd2 =0;
float simd3 =0;
float simPrevd1 =0;
float simPrevd2 =0;
float simPrevd3 =0;
float simfd1 =0;
float simfd2 =0;
float simfd3 =0;


void draw() {
  
       drawGUI();
       drawRoom();
       anchors.get(0).x =  ax;
       anchors.get(0).y =  ay;
       
       anchors.get(1).x =  bx;
       anchors.get(1).y =  by;
       
       anchors.get(2).x =  cx;
       anchors.get(2).y =  cy;

       drawAnchors();
       setDistance(0, d1);
       setDistance(1, d2);
       setDistance(2, d3);
       checkAnchorState();
         if(simulation){
             f+=0.005;
             
             simd1 = 1+abs(sin(f)*2);
             simd2 = 1+abs(cos(f)*2+sin(f*2)*2);
             simd3 = 1+abs(cos(f+random(0,0.2))*2+sin(f/2)*2);
       
             if(!filter_){
             d1 = 1+abs(sin(f)*2);
             d2 = 1+abs(cos(f)*2+sin(f*2)*2);
             d3 = 1+abs(cos(f+random(0,0.2))*2+sin(f/2)*2);
             }else{
              simfd1 = filterRange(simd1, simPrevd1, filterValue);
              if(simfd1>0 &&(abs(simfd1-simPrevd1)<0.2)){
                d1 = simfd1;
                 simPrevd1 = d1;
             }
             simfd2 = filterRange(simd2, simPrevd2, filterValue);
              if(simfd2>0 &&(abs(simfd2-simPrevd2)<0.2)){
                d2 = simfd2;
                 simPrevd2 = d2;
             }
             simfd3 = filterRange(simd3, simPrevd3, filterValue);
              if(simfd3>0 &&(abs(simfd3-simPrevd3)<0.2)){
                d3 = simfd3;
                 simPrevd3 = d3;
             }
             }
         }else{
           
             if(!editing && !simulation){
               //getData(); // Collect data from 3 Anchors
                 if(nextData){
                nextData=false;
               thread("getData");
              }
             }
             
            
             
         }

       track();
       
       //TODO: remove (red box)
       if(tx >= 730 && tx <= (730+40)){
         if(ty >= 400 && ty <= (400+40)){
           
           fill(0,255,0,40);
           rect(730,400, 40, 40);
          
         }else{
         rect(730,400, 40, 40);
       }
       }
       else{
         rect(730,400, 40, 40);
       }
    //----------------------------




 if(logging && !editing){
   startLogging();
 }
    
}

 