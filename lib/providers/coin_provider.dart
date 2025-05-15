import 'package:flutter/material.dart';
import '../services/handle_storage.dart';
import '../models/inventory.dart';

//handles every user interaction with inventory
class CoinProvider with ChangeNotifier, WidgetsBindingObserver {
  Inventory inventory = Inventory();
  late HandleStorage storage;
  CoinProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //saves inventory data when app is in background or closed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      saveInventory();
    }
  }

  void setStorage(HandleStorage handle) {
    storage = handle;
  }

  //takes map of pet stats and assigns values to current Inventory object
  Future<void> loadInventory() async {
    final bag = await storage.loadInventory();
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

  //save inventory and notify's listener
  void saveInventory() {
    storage.saveInventory(inventory);
    notifyListeners();
  }

  //coin inteactions
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

  //item usage interaction: everytime an item is used -1
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

  //item buying interactions
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
    ); 
    saveInventory();
  }
}
