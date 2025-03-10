import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  Pet pet = Pet(name: 'Fluffy');

  void feedPet() {
    pet.hunger += 20;
    if (pet.hunger > 100) pet.hunger = 100;
    notifyListeners();
  }

  void cleanPet() {
    pet.hygiene += 20;
    if (pet.hygiene > 100) pet.hygiene = 100;
    notifyListeners();
  }

  void playWithPet() {
    pet.energy -= 5;
    if (pet.energy < 0) pet.energy = 0;
    notifyListeners();
  }

  void addCoins(int amount) {
    pet.coins += amount;
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (pet.coins >= amount) {
      pet.coins -= amount;
      notifyListeners();
    }
  }
}
