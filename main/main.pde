public final static int fieldX = 900;
public final static int fieldY = 600;

public Metaball[] metaballs;
float metaballThreshold = 4;
int numMetaballs = 100;
float[][] charges = new float[fieldX][fieldY];
int r = 0;
int g = 0;
int b = 0;
float fieldCharge = 0;
String clickText = "click.";
int spacing = 3;

void setup(){
  size(900, 600, P2D);
  frameRate(10);
  metaballs = new Metaball[numMetaballs];
  for(int i = 0; i < numMetaballs; i++){
    metaballs[i] = new Metaball();
  }
  updateChargeArray();
  background(0);
  textFont(createFont("Helvetica", 32));
  //$("#load-text").hide();
  //renderMetaballs();
}

void draw(){
  fill(255);
  text(clickText, fieldX/2-20, fieldY/2);
}

void mouseClicked(){
  if(clickText == "click."){
    background(0);    }
  clickText = "";
  int x = mouseX;
  int y = mouseY;
  setRandomNiceColor();
  fieldCharge = charges[x][y];
  spread(x, y);
}

public void setRandomColor(){
  r = int(random(10, 255));
  g = int(random(10, 255));
  b = int(random(10, 255));
}

public void setCoordinateBasedColor(int x, int y){
  r = int(255/900.0 * x);
  g = int(255/600.0 * y);
  b = int(255 - 255/900.0 * y);
}

public void setRandomNiceColor(){
  int rand = int(random(0, 13));
  if(rand == 0){
    r = 247;
    g = 133;
    b = 54;
  }
  else if(rand == 1){
    r = 112;
    g = 17;
    b = 18;
  }
  else if(rand == 2){
    r = 43;
    g = 68;
    b = 80;
  }
  else if(rand == 3){
    r = 46;
    g = 56;
    b = 55;
  }
  else if(rand == 4){
    r = 22;
    g = 102;
    b = 120;
  }
  else if(rand == 5){
    r = 125;
    g = 185;
    b = 179;
  }
  else if(rand == 6){
    r = 225;
    g = 246;
    b = 244;
  }
  else if(rand == 7){
    r = 34;
    g = 40;
    b = 49;
  }
  else if(rand == 8){
    r = 0;
    g = 173;
    b = 181;
  }
  else if(rand == 9){
    r = 238;
    g = 238;
    b = 238;
  }
  else if(rand == 10){
    r = 0;
    g = 74;
    b = 85;
  }
  else if(rand == 11){
    r = 0;
    g = 74;
    b = 85;
  }
  else if(rand == 12){
    r = 255;
    g = 204;
    b = 0;
  }
}

public void spread(int x, int y){
  try{
    set(x, y, color(r,g,b));
    if(x-spacing >= 0 && get(x-spacing, y) != color(r,g,b) && charges[x-spacing][y] == fieldCharge) spread(x-spacing, y);
    if(x+spacing < fieldX && get(x+spacing, y) != color(r,g,b) && charges[x+spacing][y] == fieldCharge) spread(x+spacing, y);
    if(y-spacing >= 0 && get(x, y-spacing) != color(r,g,b) && charges[x][y-spacing] == fieldCharge) spread(x, y-spacing);
    if(y+spacing < fieldY && get(x, y+spacing) != color(r,g,b) && charges[x][y+spacing] == fieldCharge) spread(x, y+spacing);
  }
  catch(StackOverflowError e){
    return;
  }
}

public float netChargeHere(Vector2D here){
  float total = 0;
  for(int i = 0; i < metaballs.length; i++){
      Metaball m = metaballs[i];
      total += m.chargeFrom(here);
  }
  return total;
}

public void updateChargeArray(){
  for(int i = 0; i < fieldX; i++){
    for(int j = 0; j < fieldY; j++){
      Vector2D here = new Vector2D(i, j);
      float chargeHere = netChargeHere(here);
      if(chargeHere > 100) charges[i][j] = 100;
      else if(chargeHere < -100) charges[i][j] = -100;
      else if(chargeHere > 30) charges[i][j] = 30;
      else if(chargeHere < -30) charges[i][j] = -30;
      else if(chargeHere > 9) charges[i][j] = 9;
      else if(chargeHere < -9) charges[i][j] = -9;
      else if(chargeHere > 5) charges[i][j] = 5;
      else if(chargeHere < -5) charges[i][j] = -5;
      else if(chargeHere > 3) charges[i][j] = 3;
      else if(chargeHere < -3) charges[i][j] = -3;
      else if(chargeHere > 2) charges[i][j] = 2;
      else if(chargeHere < -2) charges[i][j] = -2;
      else if(chargeHere > 1.2) charges[i][j] = 1.2;
      else if(chargeHere < -1.2) charges[i][j] = -1.2;
      else if(chargeHere > 1) charges[i][j] = 1;
      else if(chargeHere < -1) charges[i][j] = -1;
      else if(chargeHere > .7) charges[i][j] = .7;
      else if(chargeHere < -.7) charges[i][j] = -.7;
      else if(chargeHere > .4) charges[i][j] = .4;
      else if(chargeHere < -.4) charges[i][j] = -.4;
      else charges[i][j] = 0;
    }
  }
}

public void renderMetaballs(){
  for(int i = 0; i < fieldX; i++){
    for(int j = 0; j < fieldY; j++){
      if(charges[i][j] > metaballThreshold){
        set(i, j, color(180, 80, 80));
      }
      else if(charges[i][j] < -metaballThreshold){
        set(i, j, color(80, 80, 180));
      }
      else{
        set(i, j, color(0, 0, 0));
      }
    }
  }
}
    