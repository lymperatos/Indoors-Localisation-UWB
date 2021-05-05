void keyPressed() {
  if (keyCode == ENTER) {
    
    if(editing){
      saveAnchors();
      S_ok.play();
    }
    editing = !editing;
}

  if (keyCode == TAB) { 
    if(logging){
    saveTable(table, "data/table.csv");
    logging=false;
    exportedCount = 0;
    }else{
      logging=true;
    }
             
}

    if (key == 'F') { 
 
      filter_= !filter_;
     
    }
}