import 'package:flutter/material.dart';
import 'pet_screen.dart';
import 'game_screen.dart';
import 'shop_screen.dart';
import '../widgets/coin_display.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pet Simulator')),
      body: Column(
        children: [
          CoinDisplay(),
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PetScreen()),
                ),
            child: Text('Go to Pet'),
          ),
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                ),
            child: Text('Play Game'),
          ),
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopScreen()),
                ),
            child: Text('Shop'),
          ),
        ],
      ),
    );
  }
}
