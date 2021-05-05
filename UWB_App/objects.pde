
void drawDoor(int rotation){
  //TODO: draw Door sketch
}

void drawCircularTable(float size){
  //TODO: draw Circular Table sketch
}

void drawWindow(float w, float x, float y, int r){
    //TODO: draw Window sketch
}

PImage img;
void drawRoomImage(String imgURL, float x, float y){
  img = loadImage(imgURL);
  //TODO: allow for importing a plan of a room.
}

//Drawing Room Function
void drawRoom(){
   stroke(#FFFFFF);
   strokeWeight(7);
   noFill();
   rect((width/2)-(roomH*zoom)/2,roomY,roomH*zoom,roomW*zoom);
   strokeWeight(1);
}