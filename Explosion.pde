//Bursts of fire when a laser hits a meteor

class Explosion
{
  float distance;
  float rotation;
  float offset;
  int timer;
  boolean finished;
  
  public Explosion( float d, float r )
  {
    distance = d;
    rotation = r;
    offset = random(-20,20);
    timer = 75;
    finished = false;
  }
  
  void drawBurst()
  {
    push();
    
    translate(width/2,height/2);
    rotate( rotation );
    fill(250,0,0,timer);
    circle(offset,distance,100-timer);
    timer-=3;
    if(timer<=0)
      finished = true;

    pop();
  }
}
