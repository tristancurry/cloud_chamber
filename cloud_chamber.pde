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


Particle particle1;
float c  = 100;
int electronMass = 1;
ArrayList particleList;
ArrayList dropletList;

void setup(){
  size(400,400);
  background(0);
  
  particleList = new ArrayList();
  dropletList = new ArrayList();
  
}

void draw(){
  fill(50,50,62,255);
  rect(0,0,width,height);

  
  if(mousePressed){
    Particle newParticle = new Particle(mouseX, mouseY, -1,1,1, random(50,100),random(PI/16, PI/12), random(0,TWO_PI),true);
    particleList.add(newParticle);
  }
  
  if(random(0,1)>0.99){
    newAlpha(random(0,width),random(0,height),0,random(80000,200000),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,1)>0.99){
    newBetaPlus(random(0,width),random(0,height),0,random(20,50),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,1)>0.95){
    newBetaMinus(random(0,width),random(0,height),0,random(20,50),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  if(random(0,1)>0.98){
    newGamma(random(0,width),random(0,height),0,random(105,900),random(PI/32,PI/12),random(0,TWO_PI));
  }
    
  
  if(particleList.size() != 0){
    for(int i = 0; i < particleList.size(); i++){
      Particle thisParticle = (Particle) particleList.get(i);
      thisParticle.update(0.00,0,0.005);
      thisParticle.display();
      trailDroplets(thisParticle.posX,thisParticle.posY,thisParticle.posZ, thisParticle.charge);
      if(random(0,1)>0.20 && thisParticle.charge == -1 && !thisParticle.isAnti){
        thisParticle.computeAltAzi();
        newBetaMinus(thisParticle.posX,thisParticle.posY,thisParticle.posZ,thisParticle.energy,thisParticle.alt + random(-PI/16.0,PI/16.0), thisParticle.azi + random(-PI/6.0,PI/6.0));
        particleList.remove(i);
      }
      if(random(0,1)>0.70 && thisParticle.charge == 1 && thisParticle.isAnti){
        thisParticle.computeAltAzi();
        newGamma(thisParticle.posX,thisParticle.posY,thisParticle.posZ,thisParticle.energy,thisParticle.alt + random(-PI/32.0,PI/32.0), thisParticle.azi + random(-PI/32.0,PI/32.0));
        particleList.remove(i);
      }
      if(random(0,1)>0.80 && thisParticle.charge == 0 && thisParticle.mass == 0 ){
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
      if(thisParticle.energy < 1.00){
        particleList.remove(i);
      }
      if(thisParticle.posZ < -3 || thisParticle.posZ > 70){
        particleList.remove(i);
      }
    }
  }

if(dropletList.size() !=0){
  for(int i = 0; i < dropletList.size(); i++){
    Droplet thisDroplet = (Droplet) dropletList.get(i);
    thisDroplet.update();
    thisDroplet.display();
    if(thisDroplet.posZ > 50){
      dropletList.remove(i);
    }
    }
  }


  
}

void trailDroplets(float posX, float posY, float posZ, int charge){
  int chargeMultiplier = int(pow(abs(charge),1));
  for(int i = 0; i < chargeMultiplier*int(random(3,16)); i++){
    Droplet newDroplet = new Droplet(posX + charge*3*quadrat(random(-1,1)),posY + charge*3*quadrat(random(-1,1)),posZ + charge*1*quadrat(random(-1,1)),1);
    dropletList.add(newDroplet);
  }
}
