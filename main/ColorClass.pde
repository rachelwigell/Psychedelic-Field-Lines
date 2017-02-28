public class Color {
  public int hue;
  public int sat;
  public int bri;
  
  public Color(int hue, int sat, int bri){
    this.hue = hue;
    this.sat = sat;
    this.bri = bri;
  }
  
  public Color(Color base, int hueInc, int satInc, int briInc, int multiplier){
    this.hue = makeValidHue((int) (base.hue + multiplier * hueInc));
    this.sat = makeValidHue((int) (base.sat + multiplier * satInc));
    this.bri = makeValidHue((int) (base.bri + multiplier * briInc));
  }
}