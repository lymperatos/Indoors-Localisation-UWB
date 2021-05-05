boolean editing = false;

void edit(){
  noCursor();
  stroke(255,0,0);
  textSize(22);
  line(mouseX,10,mouseX,-10);
  line(10,mouseY,-10,mouseY);
  
  line(mouseX+10,mouseY,mouseX-10,mouseY);
  line(mouseX,mouseY+10,mouseX,mouseY-10);
  
  text("x:"+((mouseX-roomX)/zoom), mouseX+50,mouseY-50);
  text("y:"+((mouseY-roomY)/zoom), mouseX+50,mouseY-30);
  
  if(mousePressed == true){
    if (keyPressed) {
          if(key == '1'){
            ax = mouseX;
            ay = mouseY;
          }else  if(key == '2'){
            bx = mouseX;
            by = mouseY;
          }else  if(key == '3'){
            cx = mouseX;
            cy = mouseY;
          }
  }
  }
}