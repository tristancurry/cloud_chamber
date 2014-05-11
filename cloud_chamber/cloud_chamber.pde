//this next program will be a cloud chamber
//by default it will simply simulate that nice effect of
//particle tracks of various types
//appearing, then sinking away into the vapour

//however, it will also take some input from the mic
//or musical input of some sort...

//spectrum, envelope etc

//use this to control things like:
//radiation type, energy and intensity
//strength and direction of em fields - some kinda patch typa thing

//need some objects

//particle - gamma, b+, b-, alpha?
//construction: charge (multiples of e), energy (eV)? , alt-azimuth
//droplet - generated along particle track
//construction: sink rate/time, depth

//actually need a range of probabilities for the following events:
//PHOTONS
//disintegrate into positron and electron (vanishingly small)
//scatter electron from atom (reasonably high!)
//ELECTRONS
//scatter electron from atom (pretty high)
//POSITRON
//annihilate with electron (pretty high), producing photon

//next stage is to incorporate customisable prob-distros for particle speeds
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioInput jingle;
FFT fftLin;
FFT fftLog;

Particle particle1;
float c  = 100;
int electronMass = 1;
float spread;
float BField;
ArrayList particleList;
ArrayList dropletList;

float screenAngle = 0;

void setup(){
  size(400,400);
  background(0);
  
  minim = new Minim(this);
  jingle = minim.getLineIn();
  
  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fftLog.logAverages( 22, 3 );
  
  particleList = new ArrayList();
  dropletList = new ArrayList();
  
}

void draw(){
  fill(0.1*fftLog.getAvg(2),0.1*fftLog.getAvg(11),1.0*fftLog.getAvg(8),216);
  rect(0,0,width,height);
  BField = 0;
  
  pushMatrix();
  screenAngle = 0.0*screenAngle + 0.00*fftLog.getAvg(26);
  //translate(width/400, height/400);
  rotate(screenAngle);
  
  fftLog.forward( jingle.mix );
  float spectrumScale = 1;
  
  for(int i = 0; i < fftLog.avgSize(); i++)
    {

      BField = BField + fftLog.getAvg(i);
      
      println(i + "..." +fftLog.getAvg(i));
      if(i == 21){
        spread = fftLog.getAvg(i);
      }
    }

  BField = BField/fftLog.avgSize();
  if(mousePressed){
    Particle newParticle = new Particle(mouseX, mouseY, -1,1,1, random(50,100),random(PI/16, PI/12), random(0,TWO_PI),true);
    particleList.add(newParticle);
  }
  
  if(random(0,fftLog.getAvg(11))>9.00){
    newAlpha(random(0,width),random(0,height),0,random(80000,200000),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,fftLog.getAvg(11))>3.61){
    newBetaPlus(random(0,width),random(0,height),0,2*fftLog.getAvg(5),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,fftLog.getAvg(3))>1.00){
    newBetaMinus(random(0,width),random(0,height),0,3*fftLog.getAvg(11),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,fftLog.getAvg(20))>3.11){
    newGamma(random(0,width),random(0,height),0,random(105,900),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  
  if(particleList.size() != 0){
    for(int i = 0; i < particleList.size(); i++){
      Particle thisParticle = (Particle) particleList.get(i);
      thisParticle.update(0.01*BField,0,0.010);
      thisParticle.display();
      //println("about to enter tdroplets");
      trailDroplets(thisParticle.posX,thisParticle.posY,thisParticle.posZ, thisParticle.charge);
      
       if(thisParticle.energy < 0.70||thisParticle.posZ < -3 || thisParticle.posZ > 50){
        particleList.remove(i);
      } else if(random(0,1)>0.00 && thisParticle.charge == -1 && !thisParticle.isAnti){
        thisParticle.computeAltAzi();
        newBetaMinus(thisParticle.posX,thisParticle.posY,thisParticle.posZ,thisParticle.energy,thisParticle.alt + random(-PI/16.0,PI/16.0), thisParticle.azi + random(-PI/3.0,PI/3.0));
        particleList.remove(i);
      } else if(random(0,1)>0.70 && thisParticle.charge == 1 && thisParticle.isAnti){
        thisParticle.computeAltAzi();
        newGamma(thisParticle.posX,thisParticle.posY,thisParticle.posZ,thisParticle.energy,thisParticle.alt + random(-PI/32.0,PI/32.0), thisParticle.azi + random(-PI/32.0,PI/32.0));
        particleList.remove(i);
      } else if(random(0,1)>0.80 && thisParticle.charge == 0 && thisParticle.mass == 0 ){
        thisParticle.computeAltAzi();
        float diverge = acos(sqrt(2*thisParticle.energy/electronMass)/4*c);
        float orthComp = (1/(2*electronMass*c))*sqrt(8*thisParticle.energy*sq(electronMass)*sq(c) - sq(thisParticle.energy));
        float divergeRotation = random(0.0, TWO_PI);//rotation of plane of divergence of e- e+ pair
        float divergeAlt = atan(orthComp*sin(divergeRotation)/(thisParticle.energy/(2*electronMass*c)));
        float divergeAzi = atan(orthComp*cos(divergeRotation)/(thisParticle.energy/(2*electronMass*c)));
        //println("alt: " + divergeAlt + " azi: " + divergeAzi);
        newBetaMinus(thisParticle.posX,thisParticle.posY,thisParticle.posZ,0.5*thisParticle.energy,thisParticle.alt + divergeAlt, thisParticle.azi + divergeAzi);
        newBetaPlus(thisParticle.posX,thisParticle.posY,thisParticle.posZ,0.5*thisParticle.energy,thisParticle.alt - divergeAlt, thisParticle.azi - divergeAzi);
        particleList.remove(i);
      }
    }
  }

if(dropletList.size() != 0){
  for(int i = 0; i < dropletList.size(); i++){
    Droplet thisDroplet = (Droplet) dropletList.get(i);
    thisDroplet.update();
    thisDroplet.display();
    if(thisDroplet.posZ > 50){
      dropletList.remove(i);
    }
    }
  }


 popMatrix(); 
}

void trailDroplets(float x, float y, float z, int chrg){
  
  int dropNum = 4*chrg;
  for(int j = 0; j < dropNum; j++){
    Droplet newDroplet = new Droplet(x + chrg*spread*quadrat(random(-1,1)),y + chrg*spread*quadrat(random(-1,1)),z + chrg*spread*quadrat(random(-1,1)),2);
    dropletList.add(newDroplet);
  }
  //println("left tdroplets");
}
