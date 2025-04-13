import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pet.dart';
import '../models/inventory.dart';

class LocalStorage {
  //getting file path of needed file
  static Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename.txtR';
  }

  Future<void> saveInventory(Inventory inventory) async {
    final path = await _getFilePath('inventoryData');
    final file = File(path);
    final content = '''
      coin:${inventory.getCoin()}
      food:${inventory.getFood()}
      soap:${inventory.getSoap()}
      ''';
    await file.writeAsString(content);
  }

  Future<Map<String, dynamic>> loadInventory() async {
    try {
      final path = await _getFilePath('inventoryData');
      final file = File(path);
      if (!await file.exists()) {
        print("file does not exist!");
        return {};
      }

      final lines = await file.readAsLines();
      final data = <String, dynamic>{};
      for (var line in lines) {
        final parts = line.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1];
          data[key] = int.tryParse(value) ?? 0;
        }
      }
      return data;
    } catch (e) {
      return {};
    }
  }


  Future<void> savePetStats(Pet pet) async {
    final path = await _getFilePath('petData');
    final file = File(path);
    final content = '''
      name:${pet.getName()}
      hunger:${pet.getHunger()}
      hygiene:${pet.getHygiene()}
      happiness:${pet.getHappiness()}
      energy:${pet.getEnergy()}
      lastUpdatedHunger:${pet.getLastUpdated('hunger').toIso8601String()}
      lastUpdatedHygiene:${pet.getLastUpdated('hygiene').toIso8601String()}
      lastUpdatedEnergy:${pet.getLastUpdated('energy').toIso8601String()}
      lastUpdatedHappiness:${pet.getLastUpdated('happiness').toIso8601String()}
      ''';
    await file.writeAsString(content);
    print('Pet data saved to ${file.path}');
  }

  Future<Map<String, dynamic>> loadPetStats() async {
    try {
      final path = await _getFilePath('petData');
      final file = File(path);
      if (!await file.exists()) {
        print("file does not exist!");
        return {};
      }

      final lines = await file.readAsLines();
      final data = <String, dynamic>{};
      for (var line in lines) {
        final parts = line.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1];
          if (key == 'lastUpdated') {
            data[key] = DateTime.tryParse(value);
          } 
          else if (key == 'name') {
            data[key] = value; // name is a string, so we keep it as a string
          } 
          else {
            data[key] = double.tryParse(value) ?? 0;
          }
        }
      }
      return data;
    } catch (e) {
      return {};
    }
  }
}
