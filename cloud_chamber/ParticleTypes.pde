  void newAlpha(float posX, float posY, float posZ, float energy, float alt, float azi){
    Particle newParticle = new Particle(posX, posY, posZ,4000,2, energy, alt, azi,false);
    particleList.add(newParticle);
  }
  
  void newBetaPlus(float posX, float posY, float posZ, float energy, float alt, float azi){
    Particle newParticle = new Particle(posX, posY, posZ,1,1, energy, alt, azi, true);
    particleList.add(newParticle);
  }
  
    void newBetaMinus(float posX, float posY, float posZ, float energy, float alt, float azi){
    Particle newParticle = new Particle(posX, posY, posZ,1,-1, energy, alt, azi,false);
    particleList.add(newParticle);
  }
  
  void newGamma(float posX, float posY, float posZ, float energy, float alt, float azi){
    Particle newParticle = new Particle(posX, posY, posZ,0,0, energy, alt, azi,false);
    particleList.add(newParticle);
  }
  
