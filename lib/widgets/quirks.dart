import 'dart:math';
import '../../providers/pet_provider.dart';
import '../../models/inventory.dart';

class PetQuirks {
  // Define pet preferences for toys
  static const Map<String, List<String>> _toyPreferences = {
    'cat': ['toy_mouse', 'ball'], // cats like mice and balls
    'dog': ['ball', 'teddy'], // dogs like balls and teddy bears  
    'dragon': ['teddy', 'toy_mouse'], // dragons like teddy bears and mice
  };

  // Define pet preferences for food
  static const Map<String, List<String>> _foodPreferences = {
    'cat': ['fish_bone', 'wet_canned_food', 'fresh_meat'], // cats prefer fish and wet food
    'dog': ['bone', 'fresh_meat', 'chicken'], // dogs prefer bones and meat
    'dragon': ['fresh_meat', 'chicken', 'wet_canned_food'], // dragons prefer meat
  };

  // Toys that all pets dislike
  static const List<String> _dislikedToys = ['scary_teddy'];

  /// Check if a pet likes a specific toy
  static bool petLikesToy(String petType, String toyName) {
    // Check if it's a universally disliked toy
    if (_dislikedToys.contains(toyName)) {
      return false;
    }
    
    // Check if the pet has preferences for this toy
    final preferences = _toyPreferences[petType.toLowerCase()];
    if (preferences != null && preferences.contains(toyName)) {
      return true;
    }
    
    // Default to neutral/like for unlisted toys
    return true;
  }

  /// Check if a pet likes a specific food
  static bool petLikesFood(String petType, String foodName) {
    final preferences = _foodPreferences[petType.toLowerCase()];
    if (preferences != null && preferences.contains(foodName)) {
      return true;
    }
    
    // For foods not in preferences, return neutral (still edible but not preferred)
    return false;
  }

  /// Get the appropriate reaction image based on pet type and whether they like the item
  static String getReactionImage(String petType, bool likes) {
    String petTypeLower = petType.toLowerCase();
    
    if (likes) {
      return 'assets/images/${petTypeLower}_likes.png';
    } else {
      return 'assets/images/${petTypeLower}_dislikes.png';
    }
  }

  /// Handle toy interaction with existing PetProvider methods
  /// Returns a map with reaction details for UI feedback
  static Map<String, dynamic> handleToyInteraction(
    PetProvider petProvider,
    Inventory inventory,
    String toyName,
  ) {
    String petType = petProvider.getPetType();
    int currentHappiness = petProvider.pet.getHappiness().toInt();
    
    // Check if the toy is owned
    if (!inventory.ownsToy(toyName)) {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': 'You don\'t own this toy!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    // Check if pet is sick
    if (petProvider.pet.getPetState() == "sick") {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is too sick to play!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    // Check if happiness is already maxed
    if (currentHappiness >= 100) {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is already very happy!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    // Check if pet has enough energy to play
    if (petProvider.pet.getEnergy() <= 10) {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is too tired to play!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    bool likes = petLikesToy(petType, toyName);
    
    if (likes) {
      // Pet likes the toy - use enhanced play interaction
      int happinessBonus = _dislikedToys.contains(toyName) ? -15 : Random().nextInt(10) + 10; // 10-20 bonus
      
      // Use existing playWithPet method (reduces energy, increases happiness)
      petProvider.playWithPet();
      
      // Add bonus happiness for liked toys
      if (happinessBonus > 0) {
        int newHappiness = (petProvider.pet.getHappiness() + happinessBonus).clamp(0, 100).toInt();
        petProvider.pet.setHappiness(newHappiness.toDouble());
        petProvider.savePetStats();
      }
      
      return {
        'success': true,
        'likes': true,
        'reactionImage': getReactionImage(petType, true),
        'message': '$petType loves playing with the $toyName!',
        'soundEffect': 'audio/toy.mp3',
        'bubbleImage': 'assets/images/$toyName.png',
      };
    } else {
      // Pet dislikes the toy - reduce happiness
      int happinessPenalty = Random().nextInt(10) + 5; // 5-15 penalty
      int newHappiness = (petProvider.pet.getHappiness() - happinessPenalty).clamp(0, 100).toInt();
      petProvider.pet.setHappiness(newHappiness.toDouble());
      
      // Still reduce energy slightly for the attempt
      int newEnergy = (petProvider.pet.getEnergy() - 5).clamp(0, 100).toInt();
      petProvider.pet.setEnergy(newEnergy.toDouble());
      
      petProvider.savePetStats();
      
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType doesn\'t like this toy...',
        'soundEffect': 'audio/angry.mp3',
        'bubbleImage': 'assets/images/$toyName.png',
      };
    }
  }

  /// Handle special food interaction (separate from basic food)
  /// Returns a map with reaction details for UI feedback
  static Map<String, dynamic> handleSpecialFoodInteraction(
    PetProvider petProvider,
    Inventory inventory,
    String foodName,
  ) {
    String petType = petProvider.getPetType();
    int currentHunger = petProvider.pet.getHunger().toInt();
    
    // Check if the food is owned
    if (!inventory.ownsFood(foodName)) {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': 'You don\'t have this food!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    // Check if pet is full
    if (currentHunger >= 100) {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is already full!',
        'soundEffect': 'audio/angry.mp3',
        'bubbleImage': 'assets/images/$foodName.png',
      };
    }

    // Check if pet is sick
    if (petProvider.pet.getPetState() == "sick") {
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is too sick to eat!',
        'soundEffect': 'audio/angry.mp3',
      };
    }

    bool likes = petLikesFood(petType, foodName);
    
    if (likes) {
      // Pet likes the food - enhanced feeding
      int hungerBonus = Random().nextInt(15) + 20; // 20-35 hunger
      int energyBonus = Random().nextInt(10) + 15; // 15-25 energy
      
      // Apply the bonuses
      int newHunger = (petProvider.pet.getHunger() + hungerBonus).clamp(0, 100).toInt();
      int newEnergy = (petProvider.pet.getEnergy() + energyBonus).clamp(0, 100).toInt();
      
      petProvider.pet.setHunger(newHunger.toDouble());
      petProvider.pet.setEnergy(newEnergy.toDouble());
      petProvider.savePetStats();
      
      // Remove the special food from inventory
      inventory.ownedFoods.remove(foodName);
      
      return {
        'success': true,
        'likes': true,
        'reactionImage': getReactionImage(petType, true),
        'message': '$petType absolutely loves this $foodName!',
        'soundEffect': 'audio/eat.mp3',
        'bubbleImage': 'assets/images/$foodName.png',
      };
    } else {
      // Pet doesn't prefer the food but will still eat it
      int hungerBonus = Random().nextInt(10) + 15; // 15-25 hunger
      int energyBonus = Random().nextInt(8) + 7; // 7-15 energy
      
      int newHunger = (petProvider.pet.getHunger() + hungerBonus).clamp(0, 100).toInt();
      int newEnergy = (petProvider.pet.getEnergy() + energyBonus).clamp(0, 100).toInt();
      
      petProvider.pet.setHunger(newHunger.toDouble());
      petProvider.pet.setEnergy(newEnergy.toDouble());
      petProvider.savePetStats();
      
      // Remove the special food from inventory
      inventory.ownedFoods.remove(foodName);
      
      return {
        'success': true,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType eats the $foodName but seems indifferent...',
        'soundEffect': 'audio/eat.mp3',
        'bubbleImage': 'assets/images/$foodName.png',
      };
    }
  }

  /// Enhanced poke interaction that considers pet preferences
  /// This enhances the existing poke() method in PetProvider
  static Map<String, dynamic> handlePokeInteraction(PetProvider petProvider) {
    String petType = petProvider.getPetType();
    
    // Use existing poke logic but provide reaction feedback
    if (petProvider.pet.getPetState() != "sick") {
      petProvider.poke(); // This adds +3 happiness
      
      return {
        'success': true,
        'likes': true,
        'reactionImage': getReactionImage(petType, true),
        'message': '$petType enjoys the attention!',
        'soundEffect': 'audio/toy.mp3', // or a specific poke sound
      };
    } else {
      petProvider.poke(); // This reduces -3 energy when sick
      
      return {
        'success': false,
        'likes': false,
        'reactionImage': getReactionImage(petType, false),
        'message': '$petType is too sick and feels worse...',
        'soundEffect': 'audio/angry.mp3',
      };
    }
  }

  /// Get a random preferred toy for a pet type from owned toys
  static String? getRandomPreferredToy(String petType, List<String> ownedToys) {
    final preferences = _toyPreferences[petType.toLowerCase()];
    if (preferences == null) return null;
    
    final availablePreferred = preferences.where((toy) => ownedToys.contains(toy)).toList();
    if (availablePreferred.isEmpty) return null;
    
    return availablePreferred[Random().nextInt(availablePreferred.length)];
  }

  /// Get a random preferred food for a pet type from owned foods
  static String? getRandomPreferredFood(String petType, List<String> ownedFoods) {
    final preferences = _foodPreferences[petType.toLowerCase()];
    if (preferences == null) return null;
    
    final availablePreferred = preferences.where((food) => ownedFoods.contains(food)).toList();
    if (availablePreferred.isEmpty) return null;
    
    return availablePreferred[Random().nextInt(availablePreferred.length)];
  }

  /// Get all toys that a pet type likes
  static List<String> getPreferredToys(String petType) {
    return _toyPreferences[petType.toLowerCase()] ?? [];
  }

  /// Get all foods that a pet type likes
  static List<String> getPreferredFoods(String petType) {
    return _foodPreferences[petType.toLowerCase()] ?? [];
  }

  /// Get toys that a pet type dislikes
  static List<String> getDislikedToys() {
    return _dislikedToys;
  }
}