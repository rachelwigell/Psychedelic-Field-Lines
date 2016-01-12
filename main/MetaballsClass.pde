public class Metaball {
  Vector2D center;
  float charge;

  public Metaball(int centerX, int centerY, float charge){
    this.center = new Vector2D(centerX, centerY);
    this.charge = charge;
  }
  
  public Metaball(Metaball toDup){
    this.center = new Vector2D(toDup.center.x, toDup.center.y);
    this.charge = toDup.charge;
  }
  
  public Metaball(){
    this.center = new Vector2D(int(random(0, fieldX)), int(random(0, fieldY)));
    float pos = random(-1, 1);
    if(pos > 0){
      this.charge = random(2400, 4800);
    }
    else{
      this.charge = random(-4800, -2400);
    }
  }
  
  public void move(Vector2D to){
    this.center = to;
  }
  
  public float distanceFromCenter(Vector2D from){
    return this.center.distanceFrom(from);
  }
  
  public float squaredDistFromCenter(Vector2D from){
    return this.center.squareRad(from);
  }
  
  public float chargeFrom(Vector2D from){
    float rad = this.distanceFromCenter(from);
    return this.charge/(rad * rad);
  } 
}