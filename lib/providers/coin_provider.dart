import 'package:flutter/material.dart';
//import '../models/game.dart';
import '../models/inventory.dart';

class CoinProvider with ChangeNotifier {
  Inventory inventory = Inventory();
  //Game game = Game();
  //int _coins = 0;

  //int get coins => inventory.getCoin();

  void addCoins(int amount) {
    inventory.setCoin(inventory.getCoin() + amount);
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (inventory.getCoin() >= amount) {
      inventory.setCoin(inventory.getCoin() - amount);
      notifyListeners();
    }
  }

  void buyFood(int num) {
    inventory.setFood(inventory.getFood() + num);
    notifyListeners();
  }

  //void resetCoins() {
  //  _coins = 0;
  //  notifyListeners();
  //}
}
