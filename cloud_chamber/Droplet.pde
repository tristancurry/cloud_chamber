class Droplet {
  
  float posX;
  float posY;
  float posZ;
  
  float sinkRate = 0;
  
  
  
  
  ///CONSTRUCTOR///
  Droplet(float _posX, float _posY, float _posZ, int _sinkRate){
   
    posX = _posX;
    posY = _posY; 
    posZ = _posZ;
    
    sinkRate = _sinkRate;
  }
  
  
  ///METHODS///
  
  void update(){
    posZ = posZ + sinkRate;
  }
  
  void display(){
    noStroke();
    fill(255,255,255, 148*(100 - posZ)/100);
    ellipse(posX, posY, 5, 4);
  }
}
