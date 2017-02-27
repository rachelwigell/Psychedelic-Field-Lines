public final static int fieldX = 1200;
public final static int fieldY = 700;

public Metaball[] metaballs;
float metaballThreshold = 4;
int numMetaballs = 150;
int[][] charges = new int[fieldX][fieldY];
boolean[][] painted;
String clickText = "click.";
ArrayList frontier;
HashMap colorMapping = new HashMap();

void setup(){
  size(1200, 700, P2D);
  frameRate(50);
  colorMode(HSB, 360, 100, 100);
  frontier = new ArrayList();
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
  frontier.add(new Vector2D(x, y, charges[x][y]));
}

public void spread(){
  for(int i = 0; i < min(ceil(.7 * frontier.size()), 2000); i++){
    Vector2D point = (Vector2D) frontier.get(0);
    Color fieldChargeColor = (Color) colorMapping.get(point.fieldCharge);
    frontier.remove(0);
    if(charges[point.x][point.y] == point.fieldCharge && !painted[point.x][point.y]){
      set(point.x, point.y, color(fieldChargeColor.hue, fieldChargeColor.sat, fieldChargeColor.bri));
      painted[point.x][point.y] = true;
      if(point.x-1 >= 0) frontier.add(new Vector2D(point.x-1, point.y, point.fieldCharge));
      if(point.x+1 < fieldX) frontier.add(new Vector2D(point.x+1, point.y, point.fieldCharge));
      if(point.y-1 >= 0) frontier.add(new Vector2D(point.x, point.y-1, point.fieldCharge));
      if(point.y+1 < fieldY) frontier.add(new Vector2D(point.x, point.y+1, point.fieldCharge));
      if(point.x-1 >= 0 && point.y-1 >= 0) frontier.add(new Vector2D(point.x-1, point.y-1, point.fieldCharge));
      if(point.x+1 < fieldX && point.y-1 >= 0) frontier.add(new Vector2D(point.x+1, point.y-1, point.fieldCharge));
      if(point.x-1 >= 0 && point.y+1 < fieldY) frontier.add(new Vector2D(point.x-1, point.y+1, point.fieldCharge));
      if(point.x+1 < fieldX && point.y+1 < fieldY) frontier.add(new Vector2D(point.x+1, point.y+1, point.fieldCharge));
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
  Color firstColor = new Color(firstHue, firstSatHSB, firstBriHSB);
  Color secondColor = new Color(secondHue, secondSatHSB, secondBriHSB);
  Color complementColor = new Color(compHue, compSatHSB, compBriHSB);
  colorMapping.put(200, firstColor);
  colorMapping.put(40, new Color(firstColor, hueInc, satInc, briInc, 1));
  colorMapping.put(18, new Color(firstColor, hueInc, satInc, briInc, 2));
  colorMapping.put(10, new Color(firstColor, hueInc, satInc, briInc, 3));
  colorMapping.put(6, new Color(firstColor, hueInc, satInc, briInc, 4));
  colorMapping.put(4, new Color(firstColor, hueInc, satInc, briInc, 5));
  colorMapping.put(2, new Color(firstColor, hueInc, satInc, briInc, 6));
  colorMapping.put(1, new Color(firstColor, hueInc, satInc, briInc, 7));
  colorMapping.put(0, complementColor);
  colorMapping.put(-1, new Color(firstColor, hueInc, satInc, briInc, 9));
  colorMapping.put(-2, new Color(firstColor, hueInc, satInc, briInc, 10));
  colorMapping.put(-4, new Color(firstColor, hueInc, satInc, briInc, 11));
  colorMapping.put(-6, new Color(firstColor, hueInc, satInc, briInc, 12));
  colorMapping.put(-10, new Color(firstColor, hueInc, satInc, briInc, 13));
  colorMapping.put(-18, new Color(firstColor, hueInc, satInc, briInc, 14));
  colorMapping.put(-40, new Color(firstColor, hueInc, satInc, briInc, 15));
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
    