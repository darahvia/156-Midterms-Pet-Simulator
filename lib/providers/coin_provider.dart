import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../models/inventory.dart';

class CoinProvider with ChangeNotifier, WidgetsBindingObserver {
  Inventory inventory = Inventory();
  late LocalStorage storage;
  CoinProvider(LocalStorage ls) {
    storage = ls;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is going into background or being closed
      saveInventory();
    }
  }

  Future<void> loadInventory() async {
    final bag = await storage.loadInventory();
    print(bag);
    bag.forEach((key, value) {
      print(
        'Key: $key, Value: $value',
      ); // Print each key and its corresponding value
    });
    inventory.setCoin(bag["coin"] ?? 50);
    inventory.setFood(bag["food"] ?? 10);
    inventory.setSoap(bag["soap"] ?? 10);
    inventory.setMedicine(bag["medicine"] ?? 3);
    saveInventory();
    notifyListeners();
  }

  void saveInventory() {
    storage.saveInventory(inventory);
    notifyListeners();
  }

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

  void useItem(String item) {
    if (item == 'food') {
      inventory.setFood(inventory.getFood() - 1);
      saveInventory();
    }
    if (item == 'soap') {
      inventory.setSoap(inventory.getSoap() - 1);
      saveInventory();
    }
    if (item == 'medicine') {
      inventory.setMedicine(inventory.getMedicine() - 1);
      saveInventory();
    }
  }

  void buyFood(int num) {
    inventory.setFood(inventory.getFood() + num);
    saveInventory();
  }

  void buySoap(int num) {
    inventory.setSoap(inventory.getFood() + num);
    saveInventory();
  }

  void buyMedicine(int num) {
    inventory.setMedicine(
      inventory.getMedicine() + num,
    ); // Add medicine to inventory
    saveInventory();
  }
}
