  /****************************\
  *     Planetary Defense      *  
  *    By: Bennett Ritchie     * 
  *                            *
  * Can YOU defend your planet *
  *  from the incoming meteor  *
  *  swarm!? No, you can't!    *
  * But hold out for as long   * 
  *  as you can, brave hero!   *
  *                            *
  * This game was designed to  *
  *  be played on a smartboard *
  *  or other touchscreen.     *
  *                            *    
  * As always, I apologize for *
  *   the sloppy and poorly    *
  *     documented code.       *
  \****************************/
  
//To do:
  //Projectiles that spiral
  //Powerup(s)
  //Waves
  //Image for laser gun

PImage planetPic[] = new PImage[8];
PImage asteroid, big;
float [][] starPos = new float[2][500];
int planet = int(random(8));
boolean laserOn = true;
int laserRecharge = 0;

ArrayList<Meteor> meteors = new ArrayList<Meteor>();
ArrayList<Explosion> bursts = new ArrayList<Explosion>();

int planetHealth = 10;
boolean gameOver = false;
boolean running = false;
int score = 0;

int gameTimer = 20000;

Score [] highScores = new Score[10];
boolean typingName = false;
char qwerty [] = {'Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M','_'};
int typeTimer = 0;
boolean showingScores = false;
String name = "";

void setup()
{
  fullScreen();
  imageMode(CENTER);
  textAlign(CENTER);
  rectMode(CENTER);
  
  //Load planets
  for( int i = 0; i < planetPic.length; i++ )
  {
    planetPic[i] = loadImage(i+".png");
    if( i == 5 )
      planetPic[i].resize(400,0);
    else
      planetPic[i].resize(200,0);
  }
  asteroid = loadImage("rock.png");
  asteroid.resize(100,0);
  big = loadImage("rock.png");
  big.resize(300,0);
  
  //Set Star positions
  for( int i = 0; i < starPos[0].length; i++ )
  {
    starPos[0][i] = random(width);
    starPos[1][i] = random(height);
  }
  
  //Creates meteors
  for( int i = 0; i < 3; i++)
    meteors.add( new Meteor() );
    
  loadGame();
  sortScores();
  saveGame();
}

void draw()
{
  drawSpace();
  if(!gameOver)
  {
    drawPlanet();
    if(running)
      drawLaser();
    drawButton();
  }
  else
    handleHighScore();
  
  if(running)
  {
    handleMeteors();
    handleBursts();
  }
  
  checkLaserButton();
  
  if( millis() > gameTimer )
  {
    gameTimer += 20000;
    meteors.add( new Meteor() );
  }
}

void displayScores()
{
  fill(0,200,0);
  textSize(height/20);
  for( int i = 0; i < highScores.length; i++ )
  {
    textAlign(RIGHT);
    text(highScores[i].name+"   ",width/2,height/11.0*(i+1));
    textAlign(LEFT);
    text(highScores[i].score,width/2,height/11.0*(i+1));
  }
  push();
  noFill();
  stroke(0,200,0);
  strokeWeight(5);
  textSize(30);
  textAlign(CENTER);
  rect(width-75,height-75,150,150);
  text("NEW\nGAME",width-75,height-85);
  pop();
}

void sortScores()
{
  int highestScore;
  int highestIndex;
  Score tempScores[] = new Score[highScores.length];
  for(int i = 0; i < highScores.length; i++)
  {
    highestScore = 0;
    highestIndex = 0;
    for( int j = 0; j < highScores.length; j++)
    {
      if( highScores[j].score > highestScore )
      {
        highestScore = highScores[j].score;
        highestIndex = j;
      }
    }
    tempScores[i] = highScores[highestIndex];
    highScores[highestIndex] = new Score();
  }
  
  highScores = tempScores;
}

void handleHighScore()
{
  if( !showingScores && millis() > typeTimer )
  {
    if( score > highScores[highScores.length-1].score )
      typingName = true;
    else
      showingScores = true;
  }
  if(typingName)
  {
    drawQwerty();
  }
  if(showingScores)
    displayScores();
  else
    drawScore();
}

void drawQwerty()
{
  fill(0,200,0);
  textSize(60);
  text(name+"_",width/2,height/3);
  textSize(30);
  for(int i = 0; i < 27; i++)
  {
    noFill();
    stroke(0,200,0);
    if( i < 10 )
    {
      rect( width/2+50-(5*100)+(100*i), (height*2/3)+40, 90, 90);
      fill(0,200,0);
      text( qwerty[i], width/2+50-(5*100)+(100*i), (height*2/3)+50 );
    }
    else if( i < 19 )
    {
      rect( width/2+50-(4.5*100)+(100*(i-10)), (height*2/3)+140, 90, 90);
      fill(0,200,0);
      text( qwerty[i], width/2+50-(4.5*100)+(100*(i-10)), (height*2/3)+150 );
    }
    else
    {
      rect( width/2+50-(4*100)+(100*(i-19)), (height*2/3)+240, 90, 90);
      fill(0,200,0);
      text( qwerty[i], width/2+50-(4*100)+(100*(i-19)), (height*2/3)+250 );
    }
  }
  noFill();
  rect(width/6,height*4/5,200,100);
  text("DELETE",width/6,height*4/5+10);
  rect(width*5/6,height*4/5,200,100);
  text("ENTER",width*5/6,height*4/5+10);
}

void checkLaserButton()
{
  float rotation = atan2( mouseY-height/2, mouseX-width/2 );
  rotation += HALF_PI;
  if(rotation > -0.46 && rotation < 0.46)
  {
    if(!running)
    {
      running = true;
      gameTimer = 20000+millis();
    }
    laserOn = true;
    laserRecharge += 15;
    if(laserRecharge>900)
      laserRecharge=900;
  }
}

void handleMeteors()
{
  for(int i =0; i < meteors.size(); i++)
  {
    meteors.get(i).moveAndDraw();
    if( meteors.get(i).destroyed )
    {
      meteors.remove(i);
      if(!gameOver)
        meteors.add(i, new Meteor());
      else
        i--;
    }
  }
}

void handleBursts()
{
  for( int i = 0; i < bursts.size(); i++)
  {
    bursts.get(i).drawBurst();
    if( bursts.get(i).finished )
    {
      bursts.remove(i);
      i--;
    }
  }
}

void drawScore()
{
  push();
  textSize(50);
  fill(255);
  text("Score: " + score,width/2,height/2);
  pop();
}

void drawPlanet()
{
  tint(255,(25.0*planetHealth),(25.0*planetHealth));
  image(planetPic[planet], width/2,height/2);
}

void damagePlanet( int damage )
{
  planetHealth-=damage;
  if(planetHealth<=0)
  {
    gameOver = true;
    typeTimer = millis()+2000;
  }
}

void drawButton()
{
  push();
  stroke(0);
  fill(200);
  quad(width/2-310,0, width/2-230,80, width/2+230,80, width/2+310,0);
  quad(width/2-300,0, width/2-225,75, width/2+225,75, width/2+300,0);
  fill(0,0,200);
  if(running)
  {
    textSize(30);
    text("LASER BATTERY CHARGE",width/2,35);  fill(200,0,0);
    quad(width/2-220,70, width/2-240,50, width/2+240,50, width/2+220,70);
    fill(0,200,0);
    noStroke();
    quad(width/2-220,70, width/2-239,51, width/2-239+(480*(laserRecharge/900.0)),51, width/2-219+(440*(laserRecharge/900.0)),70);
    //noStroke();
    //stroke(0,255,0,200);
    //strokeWeight(8);
    //line(width/2-220,80, width/2+220,80);
    //strokeWeight(4);
    //line(width/2-220,80, width/2+220,80);
  }
  else
  {
    textSize(38);
    text("ACTIVATE DEFENSE LASER",width/2,50);
  }
  pop();
}

void drawLaser()
{
  float rotation = atan2( mouseY-height/2, mouseX-width/2 );
  rotation += HALF_PI;
  push();
  translate(width/2,height/2);
  rotate( rotation );
  triangle(0,-160,50,-110,-50,-110);
  if(laserOn)
  {
    stroke(0,255,0,150);
    strokeWeight(5+(laserRecharge/100));
    line(0,-160,0,-1200);
    stroke(0,255,0,laserRecharge+50);
    strokeWeight(2+(laserRecharge/200));
    line(0,-160,0,-1200);
  }
  pop();
  
  for( Meteor m: meteors )
  {
    if( laserOn && !m.destroyed )
    if( !m.bigOne && abs( (rotation+PI)%TWO_PI - m.rotation ) < .05 ||
         m.bigOne && abs( (rotation+PI)%TWO_PI - m.rotation ) < .1  )
    {
      if(m.bigOne)
        bursts.add( new Explosion( m.distance-100, m.rotation ) );
      else
        bursts.add( new Explosion( m.distance-50, m.rotation ) );
      m.health--;
      if(m.health<=0)
      {
        score++;
        m.destroyed = true;
      }
    }
  }
  
  if(laserOn)
  {
    fill(0,200,0);
    laserRecharge-=2;
    if(laserRecharge <= 0)
      laserOn=false;
  }
}

void drawSpace()
{
  background(0);
  fill(255,255,200);
  noStroke();
  for(int i= 0; i < starPos[0].length; i++)
    circle(starPos[0][i],starPos[1][i],3);
}

char checkForLetter()
{
  for( int i = 0; i < 10; i++ )
    if( dist( mouseX, mouseY, 510+i*100, 760 ) < 50 )
      return qwerty[i];
  for( int i = 0; i < 9; i++ )
    if( dist( mouseX, mouseY, 560+i*100, 860 ) < 50 )
      return qwerty[i+10];
  for( int i = 0; i < 8; i++ )
    if( dist( mouseX, mouseY, 610+i*100, 960 ) < 50 )
      return qwerty[i+19];
      
  if( dist(mouseX,mouseY, width/6,height*4/5) < 75 )
    return '-';   
  if( dist(mouseX,mouseY, width*5/6,height*4/5) < 75 )
    return '=';
      
  return ' ';
}

void reset()
{
  planet = int(random(8));
  textAlign(CENTER);
  planetHealth = 10;
  gameOver = false;
  running = false;
  score = 0;
  laserRecharge = 0;
  gameTimer = 20000+millis();
  typingName = false;
  showingScores = false;
  name = "";
  for( int i = 0; i < starPos[0].length; i++ )
  {
    starPos[0][i] = random(width);
    starPos[1][i] = random(height);
  }
  meteors = new ArrayList<Meteor>();
  for( int i = 0; i < 3; i++)
    meteors.add( new Meteor() );
}

void mousePressed()
{
  if( showingScores && mouseX > width-150 && mouseX > height-150 )
    reset();

  if(typingName)
  {
    char letter = checkForLetter();
    if( letter == ' ' )
      return;
    else if( letter == '-' && name.length() > 0 )
      name = name.substring(0,name.length()-1);
    else if( letter == '=' && name.length() > 0 )
    {
      typingName = false;
      showingScores = true;
      highScores[highScores.length-1] = new Score( name, score );
      sortScores();
      saveGame();
    }
    else if( letter == '_' )
      name += ' ';
    else
      name += letter;
  }
}

void saveGame()
{
  try
  {
    PrintWriter pw = createWriter( "highScores.txt" );
    for(int i = 0; i < highScores.length; i++)
    {
      pw.println( highScores[i].name );
      pw.println( highScores[i].score );
    }
    
    pw.flush(); //Writes the remaining data to the file
    pw.close(); //Finishes the file
  }
  catch(Exception e)
  {
    println("SOMETHING WENT WRONG");
  }
}

void loadGame()
{
  int i = 0;
  String [] data;
  try
  {
    data = loadStrings("highScores.txt");
    for(; i < data.length; i+=2)
    {
      highScores[i/2] = new Score( data[i], Integer.parseInt(data[i+1]));
    }
  }
  catch(Exception e)
  {
    println("SOMETHING WENT WRONG");
  }
  for(; i < highScores.length; i++)
    highScores[i] = new Score();
}
