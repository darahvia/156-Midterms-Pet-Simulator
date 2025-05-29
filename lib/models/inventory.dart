// Tracks inventory items
class Inventory {
  int _coin = 0;

  // Food inventory
  Map<String, int> ownedFoods = {'biscuit': 0, 'can': 0, 'bag': 0};

  // Soap inventory
  Map<String, int> ownedSoaps = {'wipes': 0, 'soap': 0, 'shampoo': 0};

  // Toy inventory
  Map<String, int> ownedToys = {'mouse': 0, 'ball': 0, 'bear': 0};

  // Clothing inventory
  List<String> ownedClothing = [];

  // Food methods
  void addFood(String food, int num) {
    if (ownedFoods.containsKey(food)) {
      ownedFoods[food] = ownedFoods[food]! + num;
    }
  }

  bool ownsFood(String food) {
    return ownedFoods.containsKey(food) && ownedFoods[food]! > 0;
  }

  // Soap methods
  void addSoap(String soap, int num) {
    if (ownedSoaps.containsKey(soap)) {
      ownedSoaps[soap] = ownedSoaps[soap]! + num;
    }
  }

  bool ownsSoap(String soap) {
    return ownedSoaps.containsKey(soap) && ownedSoaps[soap]! > 0;
  }

  // Toy methods
  void addToy(String toy, int num) {
    if (ownedToys.containsKey(toy)) {
      ownedToys[toy] = ownedToys[toy]! + num;
    }
  }

  bool ownsToy(String toy) {
    return ownedToys.containsKey(toy) && ownedToys[toy]! > 0;
  }

  // Clothes methods

  void addClothing(String clothing) {
    if (!ownedClothing.contains(clothing)) {
      ownedClothing.add(clothing);
    }
  }

  bool ownsClothing(String clothing) {
    return ownedClothing.contains(clothing);
  }

  // Getter
  int getCoin() {
    return _coin;
  }

  int getFood(String food) {
    return ownedFoods.containsKey(food) ? ownedFoods[food]! : 0;
  }

  int getSoap(String soap) {
    return ownedSoaps.containsKey(soap) ? ownedSoaps[soap]! : 0;
  }

  int getToy(String toy) {
    return ownedToys.containsKey(toy) ? ownedToys[toy]! : 0;
  }

  // Setter
  void setCoin(int c) {
    _coin = c;
  }

  void setFood(String food, int num) {
    if (ownedFoods.containsKey(food)) {
      ownedFoods[food] = num;
    }
  }

  void setSoap(String soap, int num) {
    if (ownedSoaps.containsKey(soap)) {
      ownedSoaps[soap] = num;
    }
  }

  void setToy(String toy, int num) {
    if (ownedToys.containsKey(toy)) {
      ownedToys[toy] = num;
    }
  }
}
