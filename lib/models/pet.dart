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
  DateTime _lastUpdatedHunger = DateTime.now();
  DateTime _lastUpdatedHygiene = DateTime.now();
  DateTime _lastUpdatedEnergy = DateTime.now();
  DateTime _lastUpdatedHappiness = DateTime.now();

  // set pet state conditions based on stats
  void setState() {
    if (_isSick == true) {
      _petState = "sick";
    } else if (_hygiene < 30) {
      _petState = "dirty";
    } else if (_hunger < 30) {
      _petState = "hungry";
    } else if (_energy < 30) {
      _petState = "tired";
    } else if (_happiness < 30) {
      _petState = "sad";
    } else {
      _petState = "normal";
    }
  }

  // autodecrease and restart
  void applyElapsedTime() {
    if (!_isSick) {
      final now = DateTime.now();
      final elapsedSecondsHunger = now.difference(_lastUpdatedHunger).inSeconds;
      final elapsedSecondsHygiene =
          now.difference(_lastUpdatedHygiene).inSeconds;
      final elapsedSecondsEnergy = now.difference(_lastUpdatedEnergy).inSeconds;
      final elapsedSecondsHappiness =
          now.difference(_lastUpdatedHappiness).inSeconds;

      if (elapsedSecondsHunger > 0) {
        final decreaseAmount = (elapsedSecondsHunger / 5).floor();
        _hunger = (_hunger - (decreaseAmount * 10)).clamp(0, 100);
        _lastUpdatedHunger = DateTime.now();
      }
      if (elapsedSecondsHygiene > 0) {
        final decreaseAmount = (elapsedSecondsHygiene / 5).floor();
        _hygiene = (_hygiene - (decreaseAmount * 5)).clamp(0, 100);
        _lastUpdatedHygiene = DateTime.now();
      }
      if (elapsedSecondsEnergy > 0) {
        final decreaseAmount = (elapsedSecondsEnergy / 5).ceil();
        _energy = (_energy + (decreaseAmount * 10)).clamp(0, 100);
        _lastUpdatedEnergy = DateTime.now();
      }
      if (elapsedSecondsHappiness > 0) {
        final decreaseAmount = (elapsedSecondsHappiness / 5).floor();
        _happiness = (_happiness - (decreaseAmount * 10)).clamp(0, 100);
        _lastUpdatedHappiness = DateTime.now();
      }
    } else {
      final elapsedSecondsEnergy =
          DateTime.now().difference(_lastUpdatedEnergy).inSeconds;
      if (elapsedSecondsEnergy > 0) {
        final decreaseAmount = (elapsedSecondsEnergy / 5).floor();
        _energy = (_energy - (decreaseAmount * 10)).clamp(0, 100);
        _lastUpdatedEnergy = DateTime.now();
      }
    }
    printStats('updated');
    setState();
  }

  // setter
  void setName(String n) {
    _name = n;
  }

  void setHunger(double h) {
    _hunger = h;
    _lastUpdatedHunger = DateTime.now();
    setState();
  }

  void setHygiene(double hy) {
    _hygiene = hy;
    _lastUpdatedHygiene = DateTime.now();
    setState();
  }

  void setEnergy(double e) {
    _energy = e;
    _lastUpdatedEnergy = DateTime.now();
    setState();
  }

  void setHappiness(double ha) {
    _happiness = ha;
    _lastUpdatedHappiness = DateTime.now();
    setState();
  }

  void setIsSick(bool sick) {
    _isSick = sick;
    setState();
  }

  void setLastUpdated(String stat, DateTime lu) {
    if (stat == 'hunger') {
      _lastUpdatedHunger = lu;
    } else if (stat == 'hygiene') {
      _lastUpdatedHygiene = lu;
    } else if (stat == 'energy') {
      _lastUpdatedEnergy = lu;
    } else if (stat == 'happiness') {
      _lastUpdatedHappiness = lu;
    }
  }

  //getter
  String getName() {
    return _name;
  }

  double getHunger() {
    return _hunger;
  }

  double getHygiene() {
    return _hygiene;
  }

  double getEnergy() {
    return _energy;
  }

  double getHappiness() {
    return _happiness;
  }

  bool getIsSick() {
    return _isSick;
  }

  DateTime getLastUpdated(String stat) {
    if (stat == 'hunger') {
      return _lastUpdatedHunger;
    } else if (stat == 'hygiene') {
      return _lastUpdatedHygiene;
    } else if (stat == 'energy') {
      return _lastUpdatedEnergy;
    } else if (stat == 'happiness') {
      return _lastUpdatedHappiness;
    }

    return DateTime.now();
  }

  String getPetState() {
    return _petState;
  }

  void printStats(String action) {
    print(
      '$action - Hunger: $_hunger, Hygiene: $_hygiene, Happiness: $_happiness, Energy: $_energy Health: $_isSick',
    );
  }
}
