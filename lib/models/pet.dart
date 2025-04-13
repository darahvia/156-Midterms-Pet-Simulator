//import 'dart:ffi';

class Pet {
  String _name = "";
  String _petState = "normal";
  double _hunger = 0;
  double _energy = 0;
  double _hygiene = 0;
  double _happiness = 0;
  bool _isSick = false;
  int coins = 0;
  DateTime _lastUpdated = DateTime.now();


  void setState(){
    if (_isSick == true){
      _petState = "sick";
    }
    else if (_hygiene < 30){
      _petState = "dirty";
    }
    else if (_hunger < 30){
      _petState = "hungry";
    }
    else if (_energy < 30){
      _petState = "tired";
    }
    else if (_happiness < 30){
      _petState = "sad";
    }
    else{
      _petState = "normal";
    }
  }

  void applyElapsedTime() {
    final now = DateTime.now();
    final elapsedSeconds = now.difference(_lastUpdated).inSeconds;
    final decreaseAmount = (elapsedSeconds / 5).floor();

    if (elapsedSeconds > 0) {
      _hunger = (_hunger - (decreaseAmount * 10)).clamp(0, 100);
      _hygiene = (_hygiene - (decreaseAmount * 5)).clamp(0, 100);
      _happiness = (_happiness - (decreaseAmount * 5)).clamp(0, 100);
      _lastUpdated = DateTime.now();
    }

    if ((_hunger == 0) && (_happiness == 0) && (_hygiene == 0) && (_isSick == false)){
      _isSick = true; 
    }

    if (elapsedSeconds > 0 && _isSick) {
      _energy = (_energy - (decreaseAmount * 5)).clamp(0, 100);
      _lastUpdated = DateTime.now();
    } else if (elapsedSeconds > 0 && !_isSick) {
      _energy = (_energy + (decreaseAmount * 5)).clamp(0, 100);
      _lastUpdated = DateTime.now();
    }
    printStats('updated');
    setState();
  }

  void applyAutoDecrease(){
    if (!_isSick){
      _hunger = (_hunger - 10).clamp(0,100);
      _hygiene = (_hygiene - 10).clamp(0,100);
      _energy = (_energy + 5).clamp(0,100);
      _happiness = (_happiness - 5);
      _lastUpdated = DateTime.now();
    }
    else{
      _energy = (_energy - 5).clamp(0,100);
      _lastUpdated = DateTime.now();
    }
  }

  void setName(String n) {
    _name = n;
  }

  void setHunger(double h){
    _hunger = h;
    _lastUpdated = DateTime.now();
    setState();
  }

  void setHygiene(double hy){
    _hygiene = hy;
    _lastUpdated = DateTime.now();
    setState();
  }

  void setEnergy(double e){
    _energy = e;
    _lastUpdated = DateTime.now();
    setState();
  }

  void setHappiness(double ha){
    _happiness = ha;
    _lastUpdated = DateTime.now();
    setState();
  }

  void setIsSick(bool sick){
    _isSick = sick;
    setState();
  }
  
  void setLastUpdated(DateTime lu){
    _lastUpdated = lu;
  }

  String getName() {
    return _name;
  }

  double getHunger(){
    return _hunger;
  }

  double getHygiene(){
    return _hygiene;
  }

  double getEnergy(){
    return _energy;
  }

  double getHappiness(){
    return _happiness;
  }

  bool getIsSick(){
    return _isSick;
  }
  
  DateTime getLastUpdated(){
    return _lastUpdated;
  }

  String getPetState(){
    return _petState;
  }

  void printStats(String action) {
    print('$action - Hunger: $_hunger, Hygiene: $_hygiene, Happiness: $_happiness, Energy: $_energy Health: $_isSick');
  }

}
