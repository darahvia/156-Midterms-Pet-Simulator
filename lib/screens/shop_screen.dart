// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Column(
        children: [
          ListTile(
            title: Text('Food - 10 coins'),
            trailing: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 10) {
                  coinProvider.spendCoins(10);
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

          ListTile(
            title: Text('Toy - 15 coins'),
            trailing: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 15) {
                  coinProvider.spendCoins(15);
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

          ListTile(
            title: Text('Medicine - 20 coins'),
            trailing: ElevatedButton(
              onPressed: () {
                if (petProvider.pet.coins >= 20) {
                  coinProvider.spendCoins(20);
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
