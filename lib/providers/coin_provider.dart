import 'package:flutter/material.dart';
import '../models/game.dart';

class CoinProvider with ChangeNotifier {
  Game game = Game();
  int _coins = 0;

  int get coins => _coins;

  void addCoins(int amount) {
    game.coins += amount;
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (game.coins >= amount) {
      game.coins -= amount;
      notifyListeners();
    }
  }

  void resetCoins() {
    _coins = 0;
    notifyListeners();
  }
}
