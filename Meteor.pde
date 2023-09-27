class Meteor
{
  float rotation;
  float spin,spinSpeed;
  float distance;
  int health;
  float speed;
  boolean destroyed = false;
  
  public Meteor() //2.5 - 3.75
  {
    do{ rotation = random(TWO_PI); } while( (rotation < 3.85 && rotation > 2.5) || (rotation < 0.6 || rotation > 5.7) );
    println(rotation);
    distance = 1500;
    speed = random(1,4);
    health = 2*int(20/speed);
    
    spin = random(TWO_PI);
    spinSpeed = speed/100;
  }
  
  void moveAndDraw()
  {
    distance-=speed;
    
    if( distance < 160 )
    {
      destroyed = true;
      damagePlanet();
    }
    push();
      translate(width/2,height/2);
      rotate( rotation );
      tint(90+(max(1,(5-health))*30),70,30);
      push();
        translate(0,distance);
        rotate(spin);
        image(asteroid,0,0);
      pop();
      //fill(255);
      //text(rotation,0,distance);
      spin+=spinSpeed;
    pop();

  }
}
