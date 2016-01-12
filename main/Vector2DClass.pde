public class Vector2D {
  public int x;
  public int y;
  
  public Vector2D(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public float distanceFrom(Vector2D from){
    return (float) sqrt((this.x - from.x)*(this.x-from.x) + (this.y - from.y)*(this.y-from.y));
  }
  
  public float squareRad(Vector2D from){
    return (float) (this.x - from.x)*(this.x-from.x) + (this.y - from.y)*(this.y-from.y);
  }
  
  public boolean samePoint(Vector2D as){
    return (this.x == as.x && this.y == as.y);
  }
}