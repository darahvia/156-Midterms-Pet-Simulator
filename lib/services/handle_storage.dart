import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pet.dart';
import '../models/inventory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//handles manipulation of data saved in txt files
class HandleStorage {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

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
      lastUpdated:${DateTime.now().toIso8601String()}
      ''';
    await file.writeAsString(content);

    if (uid != null) {
      final inventoryData = {
        'coin': inventory.getCoin(),
        'food': inventory.getFood(),
        'soap': inventory.getSoap(),
        'medicine': inventory.getMedicine(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await _firestore.collection('users').doc(uid).set(
        {'inventoryData': inventoryData},
        SetOptions(merge: true),
      );
    }
  }

  //finds inventoryData and returns it as map of inventory values
  Future<Map<String, dynamic>> loadInventory() async {
    Map<String, dynamic> localData = {};
    DateTime? localLastUpdated;

    try {
      final path = await _getFilePath('inventoryData');
      final file = File(path);
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          final parts = line.split(':');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1];
            if (key == 'lastUpdated'){
              localData[key] = DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
              localLastUpdated = localData[key];
            }
            else{
              localData[key] = int.tryParse(value) ?? 0;
            }
          }
        }
      }
    } catch (e) {
      print("Failed to read local inventory: $e");
    }

    // Try to sync with Firebase if possible
    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final fbData = doc.data()?['inventoryData'];
        if (fbData != null) {
          final fbLastUpdatedStr = fbData['lastUpdated'] as String?;
          DateTime? fbLastUpdated = fbLastUpdatedStr != null ? DateTime.tryParse(fbLastUpdatedStr) : null;

          // If Firebase data is newer than local, overwrite local
          if (fbLastUpdated != null && (localLastUpdated == null || fbLastUpdated.isAfter(localLastUpdated))) {
            // Update local file with Firebase data
            final file = File(await _getFilePath('inventoryData'));
            final content = '''
              coin:${fbData['coin']}
              food:${fbData['food']}
              soap:${fbData['soap']}
              medicine:${fbData['medicine']}
              lastUpdated:${DateTime.now().toIso8601String()}
              ''';
            await file.writeAsString(content);

            // Return Firebase data as map
            return {
              'coin': fbData['coin'],
              'food': fbData['food'],
              'soap': fbData['soap'],
              'medicine': fbData['medicine'],
              'lastUpdated': DateTime.now(),
            };
          }
        }
      }
    }

    return localData;
  }

  // handles saving of petData as txt file
  //finds and accesses petData, returns it as map with keys and values
  // ---------------- Save Pet Stats (Local + Firebase)
  Future<void> savePetStats(Pet pet) async {
    // 1. Save locally
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
      lastUpdated:${DateTime.now().toIso8601String()}
      ''';
    await file.writeAsString(content);
    print('Pet data saved locally to ${file.path}');

    // 2. Save to Firebase if logged in
    if (uid != null) {
      final petData = {
        'name': pet.getName(),
        'hunger': pet.getHunger(),
        'hygiene': pet.getHygiene(),
        'happiness': pet.getHappiness(),
        'energy': pet.getEnergy(),
        'health': pet.getIsSick(),
        'lastUpdatedHunger': pet.getLastUpdated('hunger').toIso8601String(),
        'lastUpdatedHygiene': pet.getLastUpdated('hygiene').toIso8601String(),
        'lastUpdatedEnergy': pet.getLastUpdated('energy').toIso8601String(),
        'lastUpdatedHappiness': pet.getLastUpdated('happiness').toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await _firestore.collection('users').doc(uid).set(
        {'petData': petData},
        SetOptions(merge: true),
      );
      print('Pet data saved to Firebase for user $uid');
    }
  }

  // ---------------- Load Pet Stats (Local first, then Firebase to update local if newer)
  Future<Map<String, dynamic>> loadPetStats() async {
    Map<String, dynamic> localData = {};
    DateTime? localLastUpdated;
    try {
      final path = await _getFilePath('petData');
      final file = File(path);
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          final parts = line.split(':');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1];
            if (key == 'lastUpdated') {
              localData[key] = DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
              localLastUpdated = localData[key];
            } else if (key == 'lastUpdatedHunger' || key == 'lastUpdatedHygiene' || key == 'lastUpdatedEnergy' || key == 'lastUpdatedHappiness') {
              localData[key] = DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
            } else if (key == 'name') {
              localData[key] = value;
            } else if (key == 'health') {
              localData[key] = (value.toLowerCase() == 'true');
            } else {
              localData[key] = double.tryParse(value) ?? 0;
            }
          }
        }
      }
    } catch (e) {
      print("Failed to read local pet stats: $e");
    }

    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final fbData = doc.data()?['petData'];
        if (fbData != null) {
          final fbLastUpdatedStr = fbData['lastUpdated'] as String?;
          DateTime? fbLastUpdated = fbLastUpdatedStr != null ? DateTime.tryParse(fbLastUpdatedStr) : null;

          if (fbLastUpdated != null && (localLastUpdated == null || fbLastUpdated.isAfter(localLastUpdated))) {
            // Update local file
            final file = File(await _getFilePath('petData'));
            final content = '''
              name:${fbData['name']}
              hunger:${fbData['hunger']}
              hygiene:${fbData['hygiene']}
              happiness:${fbData['happiness']}
              energy:${fbData['energy']}
              health:${fbData['health']}
              lastUpdatedHunger:${fbData['lastUpdatedHunger']}
              lastUpdatedHygiene:${fbData['lastUpdatedHygiene']}
              lastUpdatedEnergy:${fbData['lastUpdatedEnergy']}
              lastUpdatedHappiness:${fbData['lastUpdatedHappiness']}
              lastUpdated:${fbLastUpdated.toIso8601String()}
              ''';
            await file.writeAsString(content);

            return {
              'name': fbData['name'],
              'hunger': (fbData['hunger'] as num).toDouble(),
              'hygiene': (fbData['hygiene'] as num).toDouble(),
              'happiness': (fbData['happiness'] as num).toDouble(),
              'energy': (fbData['energy'] as num).toDouble(),
              'health': fbData['health'],
              'lastUpdatedHunger': fbData['lastUpdatedHunger'],
              'lastUpdatedHygiene': fbData['lastUpdatedHygiene'],
              'lastUpdatedEnergy': fbData['lastUpdatedEnergy'],
              'lastUpdatedHappiness': fbData['lastUpdatedHappiness'],
              'lastUpdated': fbLastUpdated,
            };
          }
        }
      }
    }

    return localData;
  }

  Future<void> savePetHistory(String historyEntry) async {
    final path = await _getFilePath('petHistory');
    final file = File(path);

    List<String> historyList = [];
    if (await file.exists()) {
      historyList = await file.readAsLines();
    }
    historyList.add(historyEntry);
    await file.writeAsString(historyList.join('\n'));

    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      List<String> fbHistory = [];
      if (doc.exists && doc.data()?['petHistory'] != null) {
        fbHistory = List<String>.from(doc.data()!['petHistory']);
      }
      fbHistory.add(historyEntry);
      await _firestore.collection('users').doc(uid).set(
        {'petHistory': fbHistory},
        SetOptions(merge: true),
      );
    }
  }

  Future<List<String>> loadPetHistory() async {
    final path = await _getFilePath('petHistory');
    final file = File(path);

    List<String> localHistory = [];
    if (await file.exists()) {
      localHistory = await file.readAsLines();
    }

    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['petHistory'] != null) {
        List<String> fbHistory = List<String>.from(doc.data()!['petHistory']);

        if (fbHistory.length > localHistory.length) {
          await file.writeAsString(fbHistory.join('\n'));
          return fbHistory;
        }
      }
    }

    return localHistory;
  }


  Future<void> deleteLocalData(String filename) async {
    try {
      final petFile = File(await _getFilePath(filename));

      if (await petFile.exists()) {
        await petFile.delete();
      }

    } catch (e) {
      print("Error deleting local data: $e");
    }
  }

  Future<void> deleteFbData(String filename) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
          filename : FieldValue.delete(),
        });

  }
}
