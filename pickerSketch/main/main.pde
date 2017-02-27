public final static int fieldX = 360;
public final static int fieldY = 40;
String correspondingDivId = "";

public int selectedHue = int(fieldX/2);

void setup(){
  frameRate(20);
  size(300, 40, P2D);
  colorMode(HSB, 360, 100, 100);
}

void draw(){
  background(0, 0, 255);
    for(int i=0; i<fieldX; i++){
      stroke(i, globalSat, globalBri+50);
      line(i, 10, i, fieldY);
      stroke(0, 0, 0);
      fill(0, 0, 0);
      triangle(selectedHue-5, 0, selectedHue+5, 0, selectedHue, 10);
    }
}

void mouseDragged(){
    selectedHue=mouseX;
    $("#grad1_display").attr("style", "background-color:hsl(" + selectedHue + "," + globalSat + "%," + globalBri + "%)");
}

public void setDivId(String divId){
  correspondingDivId = divId;
}