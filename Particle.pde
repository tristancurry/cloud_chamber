class Particle {
  float posX;
  float posY;  //may replace with PVectors later
  float posZ;
  int mass;
  int charge;
  float energy;
  float alt;
  float azi;

  
  float velX;
  float velY;
  float velZ;
  
  float accX;
  float accY;
  float accZ;
  
  boolean isAnti;
  
  ///CONSTRUCTOR///Runs once when object is instantiated
  
  Particle(float _posX, float _posY, float _posZ, int _mass, int _charge, float _energy, float _alt, float _azi, boolean _isAnti){
    posX = _posX;
    posY = _posY;
    posZ = _posZ;
    mass = _mass;
    charge = _charge;
    energy = _energy;
    alt = _alt;
    azi = _azi;
    
    isAnti = _isAnti;
    
    float v = 0;
    if(mass > 0){
     v = sqrt(2*energy/mass);
    } else {
     v = c; //somehow incorporate speed of light globally later!
    }
    
    float v_xy = v*cos(alt);
    
    velX = v_xy*cos(azi);
    velY = v_xy*sin(azi);
    velZ = v*sin(alt);
  }
  
  
  ///METHODS///
  void update(float _BField, float _EField, float _density){    //method to update position, velocity and acceleration of particle
    posX = posX + velX;
    posY = posY + velY;
    posZ = posZ + velZ;
    

    
    //velZ = velZ + accZ;
    
    if(mass > 0){
          accX = 1*_BField*charge*velY/mass;  //accelerations due to B-field
    accY = -1*_BField*charge*velX/mass; //assumes uniform BField, along Z-axis
    
    float v_xy1 = sqrt(sq(velX)+sq(velY));  //applying acceleration due to B-field
    velX = velX + accX;
    velY = velY + accY;
    float v_xy2 = sqrt(sq(velX)+sq(velY));
    velX = velX*(v_xy1/v_xy2);
    velY = velY*(v_xy1/v_xy2);             //there's some maths here to keep the energy constant


    velX = velX - _density*pow(abs(charge),2)*velX/mass;
    velY = velY -_density*pow(abs(charge),2)*velY/mass;
    velZ = velZ - _density*pow(abs(charge),2)*velZ/mass;
      energy = 0.5*mass*(sq(velX)+sq(velY)+sq(velZ));
    }
    
  }
  
  
  void display(){
    noStroke();
    fill(255 + 255*charge,255 - 255*charge,mass, 255*(100 - posZ)/100);
    if(energy > 1.0 && mass > 0){
      ellipse(posX,posY,0,0);
    }
    
    
  }
  
  void computeAltAzi(){
    float v_xy = sqrt(sq(velX)+sq(velY)); 
    float v = sqrt(sq(v_xy)+sq(velZ)); 
    alt = acos(velX/v_xy);
    azi = asin(velZ/v);


    
  }

  
}
