import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  Pet pet = Pet(name: 'Fluffy');

  void feedPet() {
    pet.hunger += 20;
    if (pet.hunger > 100) pet.hunger = 100; // Prevent over max
    notifyListeners();
  }

  void playWithPet() {
    pet.energy -= 15;
    if (pet.energy < 0) pet.energy = 0; // Prevent below min
    notifyListeners();
  }

  void cleanPet() {
    pet.hygiene += 20;
    if (pet.hygiene > 100) pet.hygiene = 100; // Prevent over max
    notifyListeners();
  }

  void reduceHungerOverTime() {
    pet.hunger -= 5;
    if (pet.hunger < 0) pet.hunger = 0; // Prevent below min
    notifyListeners();
  }

  void reduceHygieneOverTime() {
    pet.hygiene -= 5;
    if (pet.hygiene < 0) pet.hygiene = 0; // Prevent below min
    notifyListeners();
  }
}
