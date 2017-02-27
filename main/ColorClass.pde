public class Color {
  public int hue;
  public int sat;
  public int bri;
  
  public Color(int hue, int sat, int bri){
    this.hue = hue;
    this.sat = sat;
    this.bri = bri;
  }
  
  public Color(Color base, int increment, int multiplier, boolean differentiator){
    this.hue = makeValidHue(base.hue + multiplier * increment);
    this.sat = base.sat;
    this.bri = base.bri;
  }
}