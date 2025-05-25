import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';
import '../providers/pet_provider.dart';

class ClothingShopScreen extends StatelessWidget {
  final List<String> clothingItems = [
    'bowtie',
    'necktie',
    'hat',
    'cowboyhat',
    'glasses',
  ];

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing Shop'),
      ),
      body: ListView.builder(
        itemCount: clothingItems.length,
        itemBuilder: (context, index) {
          final item = clothingItems[index];
          final owned = coinProvider.inventory.ownsClothing(item);

          return ListTile(
            leading: Image.asset('assets/images/$item.png', width: 40, height: 40),
            title: Text(item[0].toUpperCase() + item.substring(1)),
            subtitle: Text('5 coins'),
            trailing: owned
                ? Icon(Icons.check, color: Colors.green)
                : ElevatedButton(
                    onPressed: coinProvider.inventory.getCoin() >= 5
                        ? () {
                            coinProvider.spendCoins(5);
                            coinProvider.inventory.addClothing(item);
                            coinProvider.saveInventory();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Wear $item?'),
                                content: Text('Do you want your pet to wear the $item now?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Set the pet's current clothing
                                      Provider.of<PetProvider>(context, listen: false)
                                          .setCurrentClothing(item);
                                      Navigator.pop(context); // Close dialog
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Your pet is now wearing $item!')),
                                      );
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    child: Text('Buy'),
                  ),
          );
        },
      ),
    );
  }
}