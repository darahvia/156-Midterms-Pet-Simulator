import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/local_storage.dart';
import 'dart:async';

class PetProvider with ChangeNotifier {
  Pet pet = Pet(name: 'Fluffy');
  LocalStorage storage = LocalStorage();

  PetProvider() {
    loadPetStats();
    startAutoDecrease();
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
    if (stats.isNotEmpty) {
      pet = Pet(
        name: 'fluffy',
        hunger: stats["hunger"] ?? 100,
        hygiene: stats["hygiene"] ?? 100,
        happiness: stats["happiness"] ?? 100,
        energy: stats["energy"] ?? 100,
        lastUpdated: stats["lastUpdated"] != null ? DateTime.parse(stats["lastUpdated"]) : DateTime.now(),
      );
      pet.printStats('loaded');
      pet.applyElapsedTime();
      pet.printStats('elapsed');
    }
    savePetStats();
    pet.printStats('saved');
    notifyListeners();
    startAutoDecrease();
  }

  void savePetStats() {
    storage.savePetStats(pet);
    notifyListeners();
  }

  void feedPet() {
    pet.hunger += 20;
    if (pet.hunger > 100) pet.hunger = 100;
    pet.updateLastUpdated();
    notifyListeners();
  }

  void cleanPet() {
    pet.hygiene += 30;
    if (pet.hygiene > 100) pet.hygiene = 100;
    pet.updateLastUpdated();
    notifyListeners();
  }

  void playWithPet() {
    if (pet.energy != 0){
      pet.energy -= 15;
      pet.happiness += 10;
      if (pet.energy < 0) pet.energy = 0;
      if (pet.happiness > 100) pet.happiness = 100;
      pet.updateLastUpdated();
      notifyListeners();
    }
  }

  void addCoins(int amount) {
    pet.updateLastUpdated();
    pet.coins += amount;
  }

  void spendCoins(int amount) {
    if (pet.coins >= amount) {
      pet.coins -= amount;
      pet.updateLastUpdated();
      notifyListeners();
    }
  }

}
