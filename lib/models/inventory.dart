//tracks inventory items
class Inventory {
  int _coin = 0;
  //soap items
  int _soap = 0;
  //medicine items
  int _medicine = 0;

  // Clothing inventory
  List<String> ownedClothing = [];

  // Toy inventory
  List<String> ownedToys = [];

  // Food inventory
  Map<String, int> ownedFoods = {'biscuit': 0, 'can': 0, 'bag': 0};

  void addClothing(String clothing) {
    if (!ownedClothing.contains(clothing)) {
      ownedClothing.add(clothing);
    }
  }

  bool ownsClothing(String clothing) {
    return ownedClothing.contains(clothing);
  }

  // Toy methods
  void addToy(String toy) {
    if (!ownedToys.contains(toy)) {
      ownedToys.add(toy);
    }
  }

  bool ownsToy(String toy) {
    return ownedToys.contains(toy);
  }

  // Food methods (for special foods)
  void addFood(String food, int num) {
    if (ownedFoods.containsKey(food)) {
      ownedFoods[food] = ownedFoods[food]! + num;
    }
  }

  bool ownsFood(String food) {
    return ownedFoods.containsKey(food) && ownedFoods[food]! > 0;
  }

  // getter
  int getCoin() {
    return _coin;
  }

  int getFood(String food) {
    return ownedFoods.containsKey(food) ? ownedFoods[food]! : 0;
  }

  int getSoap() {
    return _soap;
  }

  int getMedicine() {
    return _medicine;
  }

  // setter
  void setCoin(int c) {
    _coin = c;
  }

  void setFood(String food, int num) {
    if (ownedFoods.containsKey(food)) {
      ownedFoods[food] = num;
    }
  }

  void setSoap(int s) {
    _soap = s;
  }

  void setMedicine(int m) {
    _medicine = m;
  }
}
