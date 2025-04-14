import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pet.dart';
import '../models/inventory.dart';

//handles manipulation of data saved in txt files
class LocalStorage {
  //getting file path of needed file
  static Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename.txtR';
  }

  //saves inventoryData
  Future<void> saveInventory(Inventory inventory) async {
    final path = await _getFilePath('inventoryData');
    final file = File(path);
    final content = '''
      coin:${inventory.getCoin()}
      food:${inventory.getFood()}
      soap:${inventory.getSoap()}
      medicine:${inventory.getMedicine()}
      ''';
    await file.writeAsString(content);
  }

  //finds inventoryData and returns it as map of inventory values
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

  // handles saving of petData as txt file
  Future<void> savePetStats(Pet pet) async {
    final path = await _getFilePath('petData');
    final file = File(path);
    final content = '''
      name:${pet.getName()}
      hunger:${pet.getHunger()}
      hygiene:${pet.getHygiene()}
      happiness:${pet.getHappiness()}
      energy:${pet.getEnergy()}
      health:${pet.getIsSick()}
      lastUpdatedHunger:${pet.getLastUpdated('hunger').toIso8601String()}
      lastUpdatedHygiene:${pet.getLastUpdated('hygiene').toIso8601String()}
      lastUpdatedEnergy:${pet.getLastUpdated('energy').toIso8601String()}
      lastUpdatedHappiness:${pet.getLastUpdated('happiness').toIso8601String()}
      ''';
    await file.writeAsString(content);
    print('Pet data saved to ${file.path}');
  }

  //finds and accesses petData, returns it as map with keys and values
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
          //handles parsing of diff data
          if (key == 'lastUpdatedHunger' || key == 'lastUpdatedHygiene' || key == 'lastUpdatedEnergy' || key == 'lastUpdatedHappiness') {
            data[key] = DateTime.tryParse(value);
          } 
          else if (key == 'name') {
            data[key] = value; 
          }
          else if (key == 'health') {
            data[key] = (value.toLowerCase() == 'true');
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
