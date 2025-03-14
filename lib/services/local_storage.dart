import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import 'dart:convert';

class LocalStorage {
  static Future<void> saveCoins(int coins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('coins', coins);
  }

  static Future<int> getCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('coins') ?? 0;
  }

  Future<Map<String, dynamic>> loadPetStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("petData");
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return {};
  }

  Future<void> savePetStats(Pet pet) async {
    final prefs = await SharedPreferences.getInstance();
    final petData = jsonEncode({
      "hunger": pet.hunger,
      "hygiene": pet.hygiene,
      "happiness": pet.happiness,
      "energy": pet.energy,
      "lastUpdated": pet.lastUpdated.toIso8601String(),
    });
    await prefs.setString("petData", petData);
  }
}
