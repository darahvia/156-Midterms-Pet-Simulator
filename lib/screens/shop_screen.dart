// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          ListTile(
            title: Text('Food - 10 coins'),
            trailing: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 10) {
                  petProvider.spendCoins(10);
                  petProvider.feedPet();
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Not enough coins!')));
                }
              },
              child: Text('Buy'),
            ),
          ),
          // Back button
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 15) {
                  petProvider.spendCoins(15);
                  petProvider.playWithPet();
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Not enough coins!')));
                }
              },
              child: Text('Buy'),
            ),
          ),
          // Game button
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 20) {
                  petProvider.spendCoins(20);
                  petProvider.cleanPet();
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Not enough coins!')));
                }
              },
              child: Text('Buy'),
            ),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
