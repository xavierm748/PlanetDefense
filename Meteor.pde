class Meteor
{
  float rotation;
  float spin,spinSpeed;
  float distance;
  int health;
  int maxHealth;
  float speed;
  boolean destroyed = false;
  float size;
  boolean bigOne = false;
  
  public Meteor() //2.5 - 3.75
  {
    do{ rotation = random(TWO_PI); } while( (rotation < 3.85 && rotation > 2.5) || (rotation < 0.6 || rotation > 5.7) );
    distance = 1500;
    speed = random(1,4);
    maxHealth = 2*int(20/speed);
    health = maxHealth;
    size = 100;
    if( random(100) < 5 )
    {
      speed = 0.25;
      maxHealth = health = 300;
      size = 300;
      bigOne = true;
    }
    if( random(100) < 2.5 )
    {
      int swarmCount = int( random( 5,12) );
      for(int i = 0; i < swarmCount; i++)
        swarm.add( new Meteor( swarmCount/3 ) );
    }
    
    spin = random(TWO_PI);
    spinSpeed = speed/100;
  }
  
  public Meteor( int spd )
  {
    do{ rotation = random(TWO_PI); } while( (rotation < 3.85 && rotation > 2.5) || (rotation < 0.6 || rotation > 5.7) );
    distance = 1500;
    speed = spd;
    maxHealth = 1;
    health = 1;
    size = 50;
    
    spin = random(TWO_PI);
    spinSpeed = speed/50;
  }
  
  void moveAndDraw()
  {
    distance-=speed;
    
    if( distance < 140 )
    {
      destroyed = true;
      if(!bigOne)
        damagePlanet(1);
      else
        damagePlanet(9);
    }
    push();
      translate(width/2,height/2);
      rotate( rotation );
      tint(90+165.0-(165.0*((float)health/maxHealth)),70,30);
      push();
        translate(0,distance);
        rotate(spin);
        if(bigOne)
          image(big,0,0);
        else if(size==50)
          image(small,0,0);
        else
          image(asteroid,0,0);
      pop();
      spin+=spinSpeed;
    pop();

  }
  
  float hitBox() //make it easier to hit meteors that are close
  {
    return( max( 0.05, (2-distance/300)/10 ) );
  }
}
