import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/local_storage.dart';
import 'dart:async';

class PetProvider with ChangeNotifier, WidgetsBindingObserver {
  Pet pet = Pet();
  LocalStorage storage = LocalStorage();
  Timer? _timer;
  String mood = "normal";

  PetProvider() {
    WidgetsBinding.instance.addObserver(this);
    loadPetStats();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App is going into background or being closed
      savePetStats();
    }
  }

  void startAutoDecrease() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      pet.decreaseStats();
      savePetStats();
      notifyListeners();
    });
  }

  Future<void> loadPetStats() async {
    final stats = await storage.loadPetStats();
    print(stats);
    stats.forEach((key, value) {
      print('Key: $key, Value: $value');  // Print each key and its corresponding value
    });
    pet.setName(stats["name"] ?? "Fluffy");
    pet.setHunger(stats["hunger"] ?? 100);
    pet.setHygiene(stats["hygiene"] ?? 100);
    pet.setHappiness(stats["happiness"] ?? 100);
    pet.setEnergy(stats["energy"] ?? 100);
    pet.setLastUpdated(stats["lastUpdated"] != null ? DateTime.parse(stats["lastUpdated"]) : DateTime.now());
    pet.printStats('loaded');
    pet.applyElapsedTime();
    pet.printStats('elapsed');
    savePetStats();
    pet.printStats('saved');
    notifyListeners();
    startAutoDecrease();
  }

  void savePetStats() {
    mood = pet.getPestState();
    storage.savePetStats(pet);
    notifyListeners();
  }

  void feedPet() {
    pet.setHunger((pet.getHunger() + 20).clamp(0,100));
    pet.updateLastUpdated();
    savePetStats();
  }

  void cleanPet() {
    pet.setHygiene((pet.getHygiene() + 30).clamp(0,100));
    pet.updateLastUpdated();
    savePetStats();
  }

  void playWithPet() {
    if (pet.getEnergy() > 15){
      pet.setEnergy((pet.getEnergy() - 15).clamp(0,100));
      pet.setHappiness((pet.getHappiness() + 10).clamp(0,100));
      pet.updateLastUpdated();
      savePetStats();
    }
  }

  void addCoins(int amount) {
    pet.updateLastUpdated();
    pet.coins += amount;
    savePetStats();
  }

  void spendCoins(int amount) {
    if (pet.coins >= amount) {
      pet.coins -= amount;
      pet.updateLastUpdated();
      savePetStats();
    }
  }

}
