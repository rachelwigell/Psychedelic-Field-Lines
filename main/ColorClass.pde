public class Color {
  public int hue;
  public int sat;
  public int bri;
  
  public Color(int hue, int sat, int bri){
    this.hue = hue;
    this.sat = sat;
    this.bri = bri;
  }
  
  public Color(boolean[] highs, boolean complement){
    if((boolean) highs[0] && !complement) this.hue = int(random(170, 255));
    else this.hue = int(random(0, 130));
    if((boolean) highs[1] && !complement) this.sat = int(random(170, 255));
    else this.sat = int(random(0, 130));
    if((boolean) highs[2] && !complement) this.bri = int(random(170, 255));
    else this.bri = int(random(0, 130));
  }
  
  public Color(Color base, int rIncrement, int gIncrement, int bIncrement, int multiplier){
    this.hue = base.hue + multiplier * rIncrement;
    this.sat = base.sat + multiplier * gIncrement;
    this.bri = base.bri + multiplier * bIncrement;
  }
  
  public Color(Color base, int increment, int multiplier, boolean differentiator){
    this.hue = base.hue + multiplier * increment;
    this.sat = base.sat;
    this.bri = base.bri;
  }
}