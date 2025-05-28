import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/handle_storage.dart';
import 'dart:async';

//handles interactions with pet
class PetProvider with ChangeNotifier, WidgetsBindingObserver {
  Pet pet = Pet();
  late HandleStorage storage;
  Timer? _timer;
  String mood = "normal";
  String? currentClothing;
  Timer? _autoDecreaseTimer;
  bool death = false;


  PetProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //saves petData when app in backround or closed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      savePetStats();
    }
  }

  void setStorage(HandleStorage handle) {
    storage = handle;
  }

  //handles autodecrease of stats: currently set at 5s intervals
  void startAutoDecrease() {
    _autoDecreaseTimer?.cancel();
    _autoDecreaseTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      pet.applyElapsedTime(5);
      savePetStats();
    });
  }

  void stopAutoDecrease() {
    _autoDecreaseTimer?.cancel();
    _autoDecreaseTimer = null;
  }

  void checkDeath() {
    if((pet.getHunger()==0) && (pet.getHygiene()==0) && (pet.getHappiness()==0) && (pet.getEnergy()==0)){
      death = true;
    }
  }

  void petReset(){
    death = false;
  }

  //takes map of pet stats and assigns it to current Pet object
  Future<void> loadPetStats({String? petName}) async {
    final stats = await storage.loadPetStats();
    stats.forEach((key, value) {
      print(
        'Key: $key, Value: $value',
      ); // Print each key and its corresponding value
    });
    pet.setName(stats["name"] ?? petName);
    pet.setHunger(stats["hunger"] ?? 100);
    pet.setHygiene(stats["hygiene"] ?? 100);
    pet.setHappiness(stats["happiness"] ?? 100);
    pet.setEnergy(stats["energy"] ?? 100);
    pet.setIsSick(stats["health"] ?? false);
    pet.setLastUpdated(
      'hunger',
      stats["lastUpdatedHunger"] != null
          ? DateTime.parse(stats["lastUpdatedHunger"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'hygiene',
      stats["lastUpdatedHygiene"] != null
          ? DateTime.parse(stats["lastUpdatedHygiene"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'happiness',
      stats["lastUpdatedHappiness"] != null
          ? DateTime.parse(stats["lastUpdatedHappiness"])
          : DateTime.now(),
    );
    pet.setLastUpdated(
      'energy',
      stats["lastUpdatedEnergy"] != null
          ? DateTime.parse(stats["lastUpdatedEnergy"])
          : DateTime.now(),
    );
    pet.applyElapsedTime(10);
    savePetStats();
    //checks if pet sick upon loading
    if ((pet.getHunger() == 0) &&
        (pet.getHygiene() == 0) &&
        (pet.getHappiness() == 0)) {
      pet.setIsSick(true);
    }
    savePetStats();
    startAutoDecrease();
  }

  //saving and notifying of listeners
  void savePetStats() {
    mood = pet.getPetState();
    storage.savePetStats(pet);
    checkDeath();
    notifyListeners();
  }

  //pet interactions
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

  //if pet is not sick, poke increases happiness else, decreases energy
  void poke() {
    if (pet.getPetState() != "sick") {
      pet.setHappiness((pet.getHappiness() + 3).clamp(0, 100));
      savePetStats();
    } else {
      pet.setEnergy((pet.getEnergy() - 3).clamp(0, 100));
      savePetStats();
    }
  }

  //medicine interaction: all stat 100
  void healPet() {
    pet.setIsSick(false);
    pet.setHunger(100);
    pet.setHygiene(100);
    pet.setEnergy(100);
    pet.setHappiness(100);
    savePetStats();
  }

  void setCurrentClothing(String clothing) {
    currentClothing = clothing;
    notifyListeners();
  }
}
