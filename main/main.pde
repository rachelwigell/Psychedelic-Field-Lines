public final static int fieldX = 1200;
public final static int fieldY = 700;

public Metaball[] metaballs;
float metaballThreshold = 4;
int numMetaballs = 150;
int[][] charges = new int[fieldX][fieldY];
boolean[][] painted;
String clickText = "click.";
ArrayList globalFrontier;
HashMap colorMapping = new HashMap();

void setup(){
  size(1200, 700, P2D);
  frameRate(50);
  colorMode(HSB, 360, 100, 100);
  globalFrontier = new ArrayList();
  metaballs = new Metaball[numMetaballs];
  for(int i = 0; i < numMetaballs; i++){
    metaballs[i] = new Metaball();
  }
  updateChargeArray();
  setupChargeToColorMapping(true);
  background(0);
  textFont(createFont("Helvetica", 32));
  $("#load-text").hide();
}

void draw(){
  fill(0, 0, 100);
  text(clickText, fieldX/2-20, fieldY/2);
  spread();
}

void mouseClicked(){
  if(clickText == "click."){
    background(0, 0, 0);
    clickText = "";
  }
  queueClick(mouseX, mouseY);
}

public void queueClick(int x, int y){
  globalFrontier.add(new Vector2D(x, y, charges[x][y]));
}

public void spread(){
  for(int i = 0; i < min(ceil(.7 * globalFrontier.size()), 2000); i++){
    Vector2D point = (Vector2D) globalFrontier.get(0);
    Color fieldChargeColor = (Color) colorMapping.get(point.fieldCharge);
    globalFrontier.remove(0);
    if(charges[point.x][point.y] == point.fieldCharge && !painted[point.x][point.y]){
      set(point.x, point.y, color(fieldChargeColor.hue, fieldChargeColor.sat, fieldChargeColor.bri));
      painted[point.x][point.y] = true;
      if(point.x-1 >= 0) globalFrontier.add(new Vector2D(point.x-1, point.y, point.fieldCharge));
      if(point.x+1 < fieldX) globalFrontier.add(new Vector2D(point.x+1, point.y, point.fieldCharge));
      if(point.y-1 >= 0) globalFrontier.add(new Vector2D(point.x, point.y-1, point.fieldCharge));
      if(point.y+1 < fieldY) globalFrontier.add(new Vector2D(point.x, point.y+1, point.fieldCharge));
      if(point.x-1 >= 0 && point.y-1 >= 0) globalFrontier.add(new Vector2D(point.x-1, point.y-1, point.fieldCharge));
      if(point.x+1 < fieldX && point.y-1 >= 0) globalFrontier.add(new Vector2D(point.x+1, point.y-1, point.fieldCharge));
      if(point.x-1 >= 0 && point.y+1 < fieldY) globalFrontier.add(new Vector2D(point.x-1, point.y+1, point.fieldCharge));
      if(point.x+1 < fieldX && point.y+1 < fieldY) globalFrontier.add(new Vector2D(point.x+1, point.y+1, point.fieldCharge));
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
      if(chargeHere > 100) charges[i][j] = 200;
      else if(chargeHere < -100) charges[i][j] = -200;
      else if(chargeHere > 20) charges[i][j] = 40;
      else if(chargeHere < -20) charges[i][j] = -40;
      else if(chargeHere > 9) charges[i][j] = 18;
      else if(chargeHere < -9) charges[i][j] = -18;
      else if(chargeHere > 5) charges[i][j] = 10;
      else if(chargeHere < -5) charges[i][j] = -10;
      else if(chargeHere > 3) charges[i][j] = 6;
      else if(chargeHere < -3) charges[i][j] = -6;
      else if(chargeHere > 2) charges[i][j] = 4;
      else if(chargeHere < -2) charges[i][j] = -4;
      else if(chargeHere > 1) charges[i][j] = 2;
      else if(chargeHere < -1) charges[i][j] = -2;
      else if(chargeHere > .5) charges[i][j] = 1;
      else if(chargeHere < -.5) charges[i][j] = -1;
      else charges[i][j] = 0;
    }
  }
}

public void setupChargeToColorMapping(boolean init){
  initializeColors(init);
  Color firstColor = new Color(firstHue, globalSatHSB, globalBriHSB);
  Color secondColor = new Color(secondHue, globalSatHSB, globalBriHSB);
  Color complementColor = new Color(firstColor, increment, 8, true);
  complementColor.hue = complementHue;
  colorMapping.put(200, firstColor);
  colorMapping.put(40, new Color(firstColor, increment, 1, true));
  colorMapping.put(18, new Color(firstColor, increment, 2, true));
  colorMapping.put(10, new Color(firstColor, increment, 3, true));
  colorMapping.put(6, new Color(firstColor, increment, 4, true));
  colorMapping.put(4, new Color(firstColor, increment, 5, true));
  colorMapping.put(2, new Color(firstColor, increment, 6, true));
  colorMapping.put(1, new Color(firstColor, increment, 7, true));
  colorMapping.put(0, complementColor);
  colorMapping.put(-1, new Color(firstColor, increment, 9, true));
  colorMapping.put(-2, new Color(firstColor, increment, 10, true));
  colorMapping.put(-4, new Color(firstColor, increment, 11, true));
  colorMapping.put(-6, new Color(firstColor, increment, 12, true));
  colorMapping.put(-10, new Color(firstColor, increment, 13, true));
  colorMapping.put(-18, new Color(firstColor, increment, 14, true));
  colorMapping.put(-40, new Color(firstColor, increment, 15, true));
  colorMapping.put(-200, secondColor);
  painted = new boolean[fieldX][fieldY];
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
    