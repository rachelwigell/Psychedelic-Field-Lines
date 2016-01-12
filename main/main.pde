public final static int fieldX = 1200;
public final static int fieldY = 700;

public Metaball[] metaballs;
float metaballThreshold = 4;
int numMetaballs = 150;
float[][] charges = new float[fieldX][fieldY];
int r = 0;
int g = 0;
int b = 0;
float fieldCharge = 0;
String clickText = "click.";

void setup(){
  size(1200, 700, P2D);
  frameRate(10);
  metaballs = new Metaball[numMetaballs];
  for(int i = 0; i < numMetaballs; i++){
    metaballs[i] = new Metaball();
  }
  updateChargeArray();
  background(0);
  textFont(createFont("Helvetica", 32));
  $("#load-text").hide();
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
  spread2(x, y);
}

public void setRandomColor(){
  r = int(random(10, 255));
  g = int(random(10, 255));
  b = int(random(10, 255));
}

public void setRandomBrightColor(){
  r = int(random(100, 255));
  g = int(random(100, 255));
  b = int(random(100, 255));
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
    if(x-1 >= 0 && get(x-1, y) != color(r,g,b) && charges[x-1][y] == fieldCharge) spread(x-1, y);
    if(x+1 < fieldX && get(x+1, y) != color(r,g,b) && charges[x+1][y] == fieldCharge) spread(x+1, y);
    if(y-1 >= 0 && get(x, y-1) != color(r,g,b) && charges[x][y-1] == fieldCharge) spread(x, y-1);
    if(y+1 < fieldY && get(x, y+1) != color(r,g,b) && charges[x][y+1] == fieldCharge) spread(x, y+1);
  }
  catch(StackOverflowError e){
    return;
  }
}

public void spread2(int x, int y){
  ArrayList frontier = new ArrayList();
  frontier.add(new Vector2D(x, y));
  for(int i = 0; i < frontier.size(); i++){
    Vector2D point = (Vector2D) frontier.get(i);
    if(get(point.x, point.y) != color(r,g,b) && charges[point.x][point.y] == fieldCharge){
      set(point.x, point.y, color(r,g,b));
      if(point.x-1 >= 0) frontier.add(new Vector2D(point.x-1, point.y));
      if(point.x+1 < fieldX) frontier.add(new Vector2D(point.x+1, point.y));
      if(point.y-1 >= 0) frontier.add(new Vector2D(point.x, point.y-1));
      if(point.y+1 < fieldY) frontier.add(new Vector2D(point.x, point.y+1));
    }
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
      else if(chargeHere > 20) charges[i][j] = 20;
      else if(chargeHere < -20) charges[i][j] = -20;
      else if(chargeHere > 9) charges[i][j] = 9;
      else if(chargeHere < -9) charges[i][j] = -9;
      else if(chargeHere > 5) charges[i][j] = 5;
      else if(chargeHere < -5) charges[i][j] = -5;
      else if(chargeHere > 5) charges[i][j] = 5;
      else if(chargeHere < -5) charges[i][j] = -5;
      else if(chargeHere > 3) charges[i][j] = 3;
      else if(chargeHere < -3) charges[i][j] = -3;
      else if(chargeHere > 2) charges[i][j] = 2;
      else if(chargeHere < -2) charges[i][j] = -2;
      else if(chargeHere > 1) charges[i][j] = 1;
      else if(chargeHere < -1) charges[i][j] = -1;
      else if(chargeHere > .5) charges[i][j] = .5;
      else if(chargeHere < -.5) charges[i][j] = -.5;
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
    