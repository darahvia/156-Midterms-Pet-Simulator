//import 'dart:ffi';

class Pet {
  String _name = "";
  double _hunger = 0;
  double _energy = 0;
  double _hygiene = 0;
  double _happiness = 0;
  int coins = 0;
  DateTime _lastUpdated = DateTime.now();

  void decreaseStats() {
    _hunger = (_hunger - 10).clamp(0.0, 100.0);
    _hygiene = (_hygiene - 5).clamp(0.0, 100.0);
    _energy = (_energy + 10).clamp(0.0, 100.0);
    _happiness = (_happiness - 5).clamp(0.0, 100.0);
    _lastUpdated = DateTime.now();
  }

  void applyElapsedTime() {
    final now = DateTime.now();
    final elapsedSeconds = now.difference(_lastUpdated).inSeconds;

    if (elapsedSeconds > 0) {
      final decreaseAmount = (elapsedSeconds / 5).floor();
      _hunger = (_hunger - (decreaseAmount * 10)).clamp(0, 100);
      _hygiene = (_hygiene - (decreaseAmount * 5)).clamp(0, 100);
      _energy = (_energy + (decreaseAmount * 10)).clamp(0, 100);
      _happiness = (_happiness - (decreaseAmount * 5)).clamp(0, 100);
      _lastUpdated = now;
    }
  }

  void updateLastUpdated() {
    _lastUpdated = DateTime.now();
  }

  void setName(String n) {
    _name = n;
  }

  void setHunger(double h){
    _hunger = h;
  }

  void setHygiene(double hy){
    _hygiene = hy;
  }

  void setEnergy(double e){
    _energy = e;
  }

  void setHappiness(double ha){
    _happiness = ha;
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
  
  DateTime getLastUpdated(){
    return _lastUpdated;
  }

  void printStats(String action) {
    print('$action - Hunger: $_hunger, Hygiene: $_hygiene, Happiness: $_happiness, Energy: $_energy');
  }

}
