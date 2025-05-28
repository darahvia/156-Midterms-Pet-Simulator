//tracks inventory items
class Inventory {
  int _coin = 0;
  int _food = 0;
  int _soap = 0;
  int _medicine = 0;

  // Clothing inventory
  List<String> ownedClothing = [];

  // Toy inventory
  List<String> ownedToys = [];

  // Food inventory (for special foods)
  List<String> ownedFoods = [];

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
  void addFood(String food) {
    if (!ownedFoods.contains(food)) {
      ownedFoods.add(food);
    }
  }

  bool ownsFood(String food) {
    return ownedFoods.contains(food);
  }
  
  // getter
  int getCoin() {
    return _coin;
  }

  int getFood() {
    return _food;
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

  void setFood(int f) {
    _food = f;
  }

  void setSoap(int s) {
    _soap = s;
  }

  void setMedicine(int m) {
    _medicine = m;
  }
}
