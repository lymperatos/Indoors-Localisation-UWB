ArrayList<anchor> anchors = new ArrayList<anchor>();

boolean stateA = false;
boolean stateB = false;
boolean stateC = false;

float deltaAx = tx - ax;
float deltaAy = ty - ay;
float thetaA = int(atan2(deltaAy, deltaAx));

float deltaBx = tx - bx;
float deltaBy = ty - by;
float thetaB = int(atan2(deltaBy, deltaBx));

float deltaCx = tx - cx;
float deltaCy = ty - cy;
float thetaC = int(atan2(deltaCy, deltaCx));

void drawAnchors(){
    deltaAx = tx - ax; deltaBx = tx - bx; deltaCx = ty - cx;
    deltaAy = ty - ay; deltaBy = ty - by; deltaCy = ty - cy;
    thetaA = -atan2(deltaAx, deltaAy); thetaB = -atan2(deltaBx, deltaBy); thetaC = -atan2(deltaCx, deltaCy);
    
    for(int i = 0; i< anchors.size(); i++){
      anchors.get(i).drawOnScreen();
    }
    
    //ellipse(ax, ay, 10, 10); //Anchor 1
   // ellipse(bx, by, 10, 10); //Anchor 2
    // ellipse(cx, cy, 10, 10); //Anchor 2
    
    // ellipse(ax, ay, zoom*d1, zoom*d1); //Anchor 1
   //  ellipse(bx, by, zoom*d2, zoom*d2); //Anchor 2
    // ellipse(cx, cy, zoom*d3, zoom*d3); //Anchor 2
}

void addAnchor(float x , float y, int id){
  anchor a = new anchor(x, y, id);
  anchors.add(a);
}

void removeAnchor(int id){
  anchors.remove(id);
}

void setDistance(int id, float distance){
    anchors.get(id).dist = distance;
}
String AnchorsPOS = "";

void saveAnchors(){
  AnchorsPOS = ax +","+ ay +" "+ bx +","+ by +" "+ cx +","+ cy;
  String[] list = split(AnchorsPOS, ' ');
  saveStrings("data/AnchorsPOS.txt", list);
}

void readAnchors(){
  String[] lines = loadStrings("data/AnchorsPOS.txt");
  for (int i = 0 ; i < lines.length; i++) {
    if(i == 0){
      String[] a = split(lines[i], ',');
      ax = float(a[0]);
      ay = float(a[1]);
    }else if(i == 1){
      String[] a = split(lines[i], ',');
      bx = float(a[0]);
      by = float(a[1]);
    }else if(i == 2){
      String[] a = split(lines[i], ',');
      cx = float(a[0]);
      cy = float(a[1]);
    }
  }
}

class anchor{
  float x;
  float y;
  int id;
  float dist;
  
   anchor(float x, float y, int id){
    this.x = x;
    this.y = y;
    this.id = id;
  }
  
  void drawOnScreen(){
    
    stroke(anchorOutside);
    fill(anchorInside,26);
    //ellipse(x, y, 20, 20); 
    arc(x, y, 20, 20, degrees(thetaA)-HALF_PI, degrees(thetaA));
     arc(x, y, 25, 25, -degrees(thetaA)-PI, -degrees(thetaA));
    noStroke();
    fill(255);
    ellipse(x, y, 5, 5); 
    noFill();
    //pulse
    stroke(anchorOutside,100);
    //ellipse(x, y, 250*dist, 250*dist); 
    line(x,y,tx,ty);
    
    //Text
    noStroke();
    fill(255);
    textSize(15);
    if(id==0)text("A", x, y-20);
    if(id==1)text("B", x, y-20);
    if(id==2)text("C", x, y-20);
  }
  

  
}