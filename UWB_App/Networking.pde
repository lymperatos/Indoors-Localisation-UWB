import java.net.InetAddress; 

float prevd1 = 0;
float prevd2 = 0;
float prevd3 = 0;

float d1  = 0;
float d2  = 0;
float d3  = 0;

float fd1  = 0;
float fd2  = 0;
float fd3  = 0;

DatagramSocket socket;
DatagramPacket packet;

InetAddress inet;
String ip;
int port = 5005;
byte[] buf = new byte[32];

void setUpServer(){
try{
    
  InetAddress inet = InetAddress.getLocalHost(); 
    ip = inet.getHostAddress();
    
  
}catch(Exception e){
  exit();
}
  
  try {
    socket = new DatagramSocket(port); 
  }
  catch (Exception e) {
    e.printStackTrace(); 
    println(e.getMessage());
  }
}

void getData(){
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

    nextData = true;
    String[] sA = split(received,":");
    
    //x = sA[0];
    //y = sA[1];
    
     
     if(Integer.valueOf(sA[0]) == 1){
       stateA=true;
       print("1:");
       if(filter_){
         if(prevd1 == 0){
           //  d1 = float(trim(sA[1]));
           //d1 = filterRange(float(trim(sA[1])), prevd1, filterValue);
           prevd1 = float(trim(sA[1]));
         }else{
           fd1 = filterRange(float(trim(sA[1])), prevd1, filterValue);
           if(fd1>0 && (abs(fd1-prevd1)<0.2)){
            d1 = fd1;
             prevd1 = d1;
           }
         }
       }else{
          d1 = float(trim(sA[1]));
        }
       println(d1);
     }
     if(Integer.valueOf(sA[0]) == 2){
       stateB=true;
        print("2:");
        if(filter_){
         if(prevd2 == 0){
           //d2 = float(trim(sA[1]));
           // d2 = filterRange(float(trim(sA[1])), prevd2, filterValue);
            prevd2 = float(trim(sA[1]));
       }else{
         fd2 = filterRange(float(trim(sA[1])), prevd2, filterValue);
          if(fd2>0 && (abs(fd2-prevd2)<0.2)){
            d2 = fd2;
            prevd2 = d2;
           }
        
       }
        }else{
          d2 = float(trim(sA[1]));
        }
        println(d2);
     }
     
     
     if(Integer.valueOf(sA[0]) == 3){
       stateC=true;
        print("3:");
        if(filter_){
         if(prevd3 == 0){
          // d3 = float(trim(sA[1]));
          //d3 = filterRange(float(trim(sA[1])), prevd3, filterValue);
          prevd3 = float(trim(sA[1]));
       }else{
         fd3 = filterRange(float(trim(sA[1])), prevd3, filterValue);
          if(fd3>0 &&(abs(fd3-prevd3)<0.2)){
            d3 = fd3;
             prevd3 = d3;
           }
         
       }
        }else{
          d3 = float(trim(sA[1]));
        }
        println(d3);
     }
     
     return;
  }
  
  catch (IOException e) {
    e.printStackTrace(); 
    //println(e.getMessage());
    return;
  }
  
}

float filterRange(float value, float previousValue, int numberOfElements){
    float k = 2.0f / ((float)numberOfElements + 1.0f);
    return (value * k) + previousValue * (1.0f - k);   
}

int t = 0;
int wait = 1000; // 1 sec

float prev1 = 0;
float prev2 = 0;
float prev3 = 0;
void checkAnchorState(){
   if( millis()-t >= wait ){
     if(d1 == prev1){
       stateA = false;
       anchorAColor = #A11C1C;
     }else{
        anchorAColor = #75FAD4;
     }
       if(d2 == prev2){
       stateB = false;
       anchorBColor = #A11C1C;
     }else{
        anchorBColor = #75FAD4;
     }
        if(d3 == prev3){
       stateC = false;
       anchorCColor = #A11C1C;
     }else{
        anchorCColor = #75FAD4;
     }
     prev1 = d1;
     prev2 = d2;
     prev3 = d3;
    


        t=millis();
  }
}