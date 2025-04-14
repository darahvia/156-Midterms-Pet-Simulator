import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/local_storage.dart';
import 'dart:async';

class PetProvider with ChangeNotifier, WidgetsBindingObserver {
  Pet pet = Pet();
  late LocalStorage storage;
  Timer? _timer;
  String mood = "normal";

  PetProvider(LocalStorage ls) {
    storage = ls;
    WidgetsBinding.instance.addObserver(this);
    //loadPetStats();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is going into background or being closed
      savePetStats();
    }
  }

  void startAutoDecrease() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      pet.applyElapsedTime();
      savePetStats();
      //notifyListeners();
    });
  }

  Future<void> loadPetStats({String? petName}) async {
    final stats = await storage.loadPetStats();
    print(stats);
    stats.forEach((key, value) {
      print(
        'Key: $key, Value: $value',
      ); // Print each key and its corresponding value
    });
    pet.setName(stats["name"] ?? petName);
    pet.setHunger(stats["hunger"] ?? 0);
    pet.setHygiene(stats["hygiene"] ?? 0);
    pet.setHappiness(stats["happiness"] ?? 0);
    pet.setEnergy(stats["energy"] ?? 100);
    pet.setIsSick(stats["health"] ?? false);
    pet.setLastUpdated(
      'hunger',
      stats["lastUpdatedHunger"] != null
          ? DateTime.parse(stats["lastUpdated"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'hygiene',
      stats["lastUpdatedHygiene"] != null
          ? DateTime.parse(stats["lastUpdated"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'happiness',
      stats["lastUpdatedHappiness"] != null
          ? DateTime.parse(stats["lastUpdated"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'energy',
      stats["lastUpdatedEnergy"] != null
          ? DateTime.parse(stats["lastUpdated"])
          : DateTime.now(),
    );
    pet.applyElapsedTime();
    savePetStats();
    if ((pet.getHunger() == 0) &&
        (pet.getHygiene() == 0) &&
        (pet.getHappiness() == 0)) {
      pet.setIsSick(true);
    }
    savePetStats();
    pet.printStats('saved');
    //notifyListeners();
    startAutoDecrease();
  }

  void savePetStats() {
    mood = pet.getPetState();
    storage.savePetStats(pet);
    notifyListeners();
  }

  void feedPet() {
    pet.setHunger((pet.getHunger() + 20).clamp(0, 100));
    savePetStats();
  }

  void cleanPet() {
    pet.setHygiene((pet.getHygiene() + 30).clamp(0, 100));
    savePetStats();
  }

  void playWithPet() {
    if (pet.getEnergy() > 10) {
      pet.setEnergy((pet.getEnergy() - 10).clamp(0, 100));
      pet.setHappiness((pet.getHappiness() + 15).clamp(0, 100));
      savePetStats();
    }
  }

  void poke() {
    if (pet.getPetState() != "sick") {
      pet.setHappiness((pet.getHappiness() + 3).clamp(0, 100));
      savePetStats();
    } else {
      pet.setEnergy((pet.getEnergy() - 3).clamp(0, 100));
      savePetStats();
    }
  }

  void healPet() {
    pet.setIsSick(false);
    pet.setHunger(100);
    pet.setHygiene(100);
    pet.setEnergy(100);
    pet.setHappiness(100);
    savePetStats();
  }
}
