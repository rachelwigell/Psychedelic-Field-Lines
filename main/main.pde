public final static int fieldX = 1200;
public final static int fieldY = 700;

public Metaball[] metaballs;
float metaballThreshold = 4;
int numMetaballs = 150;
int[][] charges = new int[fieldX][fieldY];
boolean[][] painted = new boolean[fieldX][fieldY];
Color rgb = new Color(0, 0, 0);
float fieldCharge = 0;
String clickText = "click.";
ArrayList globalFrontier;
HashMap colorMapping = new HashMap();
seedColor = "";
apiColors = {};

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
  //setSeedColor();
  //getColorsFromAPI();
  setupChargeToColorMapping3();
  background(0);
  textFont(createFont("Helvetica", 32));
  $("#load-text").hide();
  //renderMetaballs();
}

void draw(){
  fill(255);
  text(clickText, fieldX/2-20, fieldY/2);
  spread3();
}

void mouseClicked(){
  if(clickText == "click."){
    background(0);    }
  clickText = "";
  int x = mouseX;
  int y = mouseY;
  randomNiceColor();
  queueClick(x, y);
}

public Color randomColor(){
  return new Color(int(random(10, 255)), int(random(10, 255)), int(random(10, 255)));
}

public Color randomBrightColor(){
  int thirdColor = int(random(200, 255));
  if(random(0,2) < 1)  thirdColor = int(random(0, 100));
  ArrayList order = new ArrayList();
  order.add(int(random(200, 255)));
  order.add(int(random(0, 100)));
  order.add(thirdColor);
  int index = int(random(0, 3));
  int r = (int) order.get(index);
  order.remove(index);
  index = int(random(0, 2));
  int g = (int) order.get(index);
  int b = (int) order.get(0);
  return new Color(r,g,b);
}

public void setSeedColor(){
  Color seed = randomBrightColor();
  seedColor = seed.r + "," + seed.g + "," + seed.b;
}

public Color setCoordinateBasedColor(int x, int y){
  return new Color(int(255/900.0 * x), int(255/600.0 * y), int(255 - 255/900.0 * y));
}

public Color randomNiceColor(){
  int rand = int(random(0, 13));
  if(rand == 0){
    return new Color(247, 133, 54);
  }
  else if(rand == 1){
    return new Color(112, 17, 18);
  }
  else if(rand == 2){
    return new Color(43, 68, 80);
  }
  else if(rand == 3){
    return new Color(46, 56, 55);
  }
  else if(rand == 4){
    return new Color(22, 102, 120);
  }
  else if(rand == 5){
    return new Color(125, 185, 179);
  }
  else if(rand == 6){
    return new Color(225, 246, 244);
  }
  else if(rand == 7){
    return new Color(34, 40, 49);
  }
  else if(rand == 8){
    return new Color(0, 173, 181);
  }
  else if(rand == 9){
    return new Color(238, 238, 238);
  }
  else if(rand == 10){
    return new Color(0, 74, 85);
  }
  else if(rand == 11){
    return new Color(0, 74, 85);
  }
  else if(rand == 12){
    return new Color(255, 204, 0);
  }
  return new Color(0,0,0);
}

public void spread(int x, int y){
  try{
    set(x, y, color(rgb.r, rgb.g, rgb.b));
    if(x-1 >= 0 && get(x-1, y) != color(rgb.r, rgb.g, rgb.b) && charges[x-1][y] == fieldCharge) spread(x-1, y);
    if(x+1 < fieldX && get(x+1, y) != color(rgb.r, rgb.g, rgb.b) && charges[x+1][y] == fieldCharge) spread(x+1, y);
    if(y-1 >= 0 && get(x, y-1) != color(rgb.r, rgb.g, rgb.b) && charges[x][y-1] == fieldCharge) spread(x, y-1);
    if(y+1 < fieldY && get(x, y+1) != color(rgb.r, rgb.g, rgb.b) && charges[x][y+1] == fieldCharge) spread(x, y+1);
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
    if(get(point.x, point.y) != color(rgb.r, rgb.g, rgb.b) && charges[point.x][point.y] == fieldCharge){
      set(point.x, point.y, color(rgb.r, rgb.g, rgb.b));
      if(point.x-1 >= 0) frontier.add(new Vector2D(point.x-1, point.y));
      if(point.x+1 < fieldX) frontier.add(new Vector2D(point.x+1, point.y));
      if(point.y-1 >= 0) frontier.add(new Vector2D(point.x, point.y-1));
      if(point.y+1 < fieldY) frontier.add(new Vector2D(point.x, point.y+1));
    }
  }
}

public void queueClick(int x, int y){
  globalFrontier.add(new Vector2D(x, y, charges[x][y]));
}

public void spread3(){
  for(int i = 0; i < min(ceil(.7 * globalFrontier.size()), 2000); i++){
    Vector2D point = (Vector2D) globalFrontier.get(0);
    Color fieldChargeColor = (Color) colorMapping.get(point.fieldCharge);
    globalFrontier.remove(0);
    if(charges[point.x][point.y] == point.fieldCharge && !painted[point.x][point.y]){
      set(point.x, point.y, color(fieldChargeColor.r, fieldChargeColor.g, fieldChargeColor.b));
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

public void setupChargeToColorMapping2(){
  boolean rHigh = random(0,2) < 1;
  boolean gHigh = random(0,2) < 1;
  boolean bHigh = random(0,2) < 1;
  if(rHigh == gHigh) bHigh = !rHigh;
  boolean[] order = new boolean[3];
  order[0] = rHigh;
  order[1] = gHigh;
  order[2] = bHigh;
  Color firstColor = new Color(order, false);
  Color firstComplement = new Color(order, true);
  int invert = int(random(0, 3));
  order[invert] = !order[invert];
  int secondInvert = invert;
  while(secondInvert == invert){
    invert = int(random(0,3));
  }
  order[secondInvert] = !order[secondInvert];
  Color secondColor = new Color(order, false);
  Color secondComplement = new Color(order, true);
  int rIncrement = int((secondColor.r - firstColor.r)/16);
  int gIncrement = int((secondColor.g - firstColor.g)/16);
  int bIncrement = int((secondColor.b - firstColor.b)/16);
  colorMapping.put(200, firstColor);
  colorMapping.put(40, new Color(firstColor, rIncrement, gIncrement, bIncrement, 1));
  colorMapping.put(18, new Color(firstColor, rIncrement, gIncrement, bIncrement, 2));
  colorMapping.put(10, new Color(firstColor, rIncrement, gIncrement, bIncrement, 3));
  colorMapping.put(6, new Color(firstColor, rIncrement, gIncrement, bIncrement, 4));
  colorMapping.put(4, new Color(firstColor, rIncrement, gIncrement, bIncrement, 5));
  colorMapping.put(2, new Color(firstColor, rIncrement, gIncrement, bIncrement, 6));
  colorMapping.put(1, new Color(firstColor, rIncrement, gIncrement, bIncrement, 7));
  colorMapping.put(0, new Color(firstColor, rIncrement, gIncrement, bIncrement, 8));
  colorMapping.put(-1, new Color(firstColor, rIncrement, gIncrement, bIncrement, 9));
  colorMapping.put(-2, new Color(firstColor, rIncrement, gIncrement, bIncrement, 10));
  colorMapping.put(-4, new Color(firstColor, rIncrement, gIncrement, bIncrement, 11));
  colorMapping.put(-6, new Color(firstColor, rIncrement, gIncrement, bIncrement, 12));
  colorMapping.put(-10, new Color(firstColor, rIncrement, gIncrement, bIncrement, 13));
  colorMapping.put(-18, new Color(firstColor, rIncrement, gIncrement, bIncrement, 14));
  colorMapping.put(-40, new Color(firstColor, rIncrement, gIncrement, bIncrement, 15));
  colorMapping.put(-200, secondColor);
}

public void setupChargeToColorMapping3(){
  int firstHue = int(random(0, 360));
  int secondHue = firstHue + int(random(120, 160));
  if(secondHue > 360) secondHue -= 360;
  int satIncrement = 0;
  int briIncrement = 0;
  Color firstColor = new Color(firstHue, 100, 100);
  Color secondColor = new Color(secondHue, 100, 100);
  int hueIncrement = int((secondHue - firstHue)/15);
  int complementHue = (firstHue + hueIncrement * 8) + int(random(160, 200));
  if(complementHue > 360) complementHue -= 360;
  Color complementColor = new Color(firstColor, hueIncrement, satIncrement, briIncrement, 8);
  complementColor.r = complementHue;
  colorMapping.put(200, firstColor);
  colorMapping.put(40, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 1));
  colorMapping.put(18, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 2));
  colorMapping.put(10, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 3));
  colorMapping.put(6, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 4));
  colorMapping.put(4, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 5));
  colorMapping.put(2, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 6));
  colorMapping.put(1, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 7));
  colorMapping.put(0, complementColor);
  colorMapping.put(-1, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 9));
  colorMapping.put(-2, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 10));
  colorMapping.put(-4, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 11));
  colorMapping.put(-6, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 12));
  colorMapping.put(-10, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 13));
  colorMapping.put(-18, new Color(firstColor, hueIncrement, satIncrement, briIncrement, 14));
  colorMapping.put(-40, new Color(firstColor, hueIncrement, satIncrement, briIncrement,15));
  colorMapping.put(-200, secondColor);
}

public void setupChargeToColorMapping(boolean useAPIcolors){
  if(useAPIcolors){
    colorMapping.put(200, new Color(apiColors.colors[0].rgb.r, apiColors.colors[0].rgb.g, apiColors.colors[0].rgb.b));
    colorMapping.put(-200, new Color(apiColors.colors[1].rgb.r, apiColors.colors[1].rgb.g, apiColors.colors[1].rgb.b));
    colorMapping.put(40, new Color(apiColors.colors[2].rgb.r, apiColors.colors[2].rgb.g, apiColors.colors[2].rgb.b));
    colorMapping.put(-40, new Color(apiColors.colors[3].rgb.r, apiColors.colors[3].rgb.g, apiColors.colors[3].rgb.b));
    colorMapping.put(-18, new Color(apiColors.colors[4].rgb.r, apiColors.colors[4].rgb.g, apiColors.colors[4].rgb.b));
    colorMapping.put(18, new Color(apiColors.colors[5].rgb.r, apiColors.colors[5].rgb.g, apiColors.colors[5].rgb.b));
    colorMapping.put(10, new Color(apiColors.colors[6].rgb.r, apiColors.colors[6].rgb.g, apiColors.colors[6].rgb.b));
    colorMapping.put(-10, new Color(apiColors.colors[7].rgb.r, apiColors.colors[7].rgb.g, apiColors.colors[7].rgb.b));
    colorMapping.put(6, new Color(apiColors.colors[8].rgb.r, apiColors.colors[8].rgb.g, apiColors.colors[8].rgb.b));
    colorMapping.put(-6, new Color(apiColors.colors[9].rgb.r, apiColors.colors[9].rgb.g, apiColors.colors[9].rgb.b));
    colorMapping.put(4, new Color(apiColors.colors[10].rgb.r, apiColors.colors[10].rgb.g, apiColors.colors[10].rgb.b));
    colorMapping.put(-4, new Color(apiColors.colors[11].rgb.r, apiColors.colors[11].rgb.g, apiColors.colors[11].rgb.b));
    colorMapping.put(2, new Color(apiColors.colors[12].rgb.r, apiColors.colors[12].rgb.g, apiColors.colors[12].rgb.b));
    colorMapping.put(-2, new Color(apiColors.colors[13].rgb.r, apiColors.colors[13].rgb.g, apiColors.colors[13].rgb.b));
    colorMapping.put(1, new Color(apiColors.colors[14].rgb.r, apiColors.colors[14].rgb.g, apiColors.colors[14].rgb.b));
    colorMapping.put(-1, new Color(apiColors.colors[15].rgb.r, apiColors.colors[15].rgb.g, apiColors.colors[15].rgb.b));
    colorMapping.put(0, new Color(apiColors.colors[16].rgb.r, apiColors.colors[16].rgb.g, apiColors.colors[16].rgb.b));
  }
  else{
    colorMapping.put(200, randomBrightColor());
    colorMapping.put(-200, randomBrightColor());
    colorMapping.put(40, randomBrightColor());
    colorMapping.put(-40, randomBrightColor());
    colorMapping.put(-18, randomBrightColor());
    colorMapping.put(18, randomBrightColor());
    colorMapping.put(10, randomBrightColor());
    colorMapping.put(-10, randomBrightColor());
    colorMapping.put(6, randomBrightColor());
    colorMapping.put(-6, randomBrightColor());
    colorMapping.put(4, randomBrightColor());
    colorMapping.put(-4, randomBrightColor());
    colorMapping.put(2, randomBrightColor());
    colorMapping.put(-2, randomBrightColor());
    colorMapping.put(1, randomBrightColor());
    colorMapping.put(-1, randomBrightColor());
    colorMapping.put(0, randomBrightColor());
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
    