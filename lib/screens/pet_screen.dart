// screens/pet_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/pet_display.dart';
import 'game_screen.dart';
import 'shop_screen.dart';

class PetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Pet')),
      body: Column(
        children: [
          CoinDisplay(),
          Expanded(child: PetDisplay()),
          Text('Hunger:'),
          LinearProgressIndicator(
            value: petProvider.pet.hunger / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.red,
          ),
          SizedBox(height: 10),

          Text('Energy:'),
          LinearProgressIndicator(
            value: petProvider.pet.energy / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          SizedBox(height: 10),

          Text('Hygiene:'),
          LinearProgressIndicator(
            value: petProvider.pet.hygiene / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
          SizedBox(height: 20),

          ElevatedButton(onPressed: petProvider.feedPet, child: Text('Feed')),
          ElevatedButton(onPressed: petProvider.cleanPet, child: Text('Clean')),

          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopScreen()),
                ),
            child: Text('Go to Shop'),
          ),
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                ),
            child: Text('Play Game'),
          ),
        ],
      ),
    );
  }
}
