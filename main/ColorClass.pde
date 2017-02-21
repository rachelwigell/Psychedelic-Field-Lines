public class Color {
  public int r;
  public int g;
  public int b;
  
  public Color(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  public Color(boolean[] highs, boolean complement){
    if((boolean) highs[0] && !complement) this.r = int(random(170, 255));
    else this.r = int(random(0, 130));
    if((boolean) highs[1] && !complement) this.g = int(random(170, 255));
    else this.g = int(random(0, 130));
    if((boolean) highs[2] && !complement) this.b = int(random(170, 255));
    else this.b = int(random(0, 130));
  }
  
  public Color(Color base, int rIncrement, int gIncrement, int bIncrement, int multiplier){
    this.r = base.r + multiplier * rIncrement;
    this.g = base.g + multiplier * gIncrement;
    this.b = base.b + multiplier * bIncrement;
  }
  
  public Color(Color base, int increment, int multiplier){
    this.r = base.r + multiplier * increment;
    this.g = base.g;
    this.b = base.b;
  }
}