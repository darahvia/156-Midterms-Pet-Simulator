// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/pixel_button.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    // Determine the cat's expression based on its mood
    String catImagePath;
    switch (petProvider.mood) {
      case "hungry":
        catImagePath = 'assets/images/cat_hungry.png';
        break;
      case "tired":
        catImagePath = 'assets/images/cat_tired.png';
        break;
      case "happy":
        catImagePath = 'assets/images/cat_happy.png';
        break;
      default:
        catImagePath = 'assets/images/cat_normal.png';
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/livingroom.png',
              fit: BoxFit.cover,
            ),
          ),
          // Coins display
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.yellow, size: 32),
                SizedBox(width: 8),
                Text(
                  '${coinProvider.inventory.getCoin()} Coins', // Use inventory.getCoin()
                  style: GoogleFonts.pressStart2p(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Cat image positioned in the lower-right corner
          Positioned(
            bottom: 16,
            right: 16, // Position the cat in the lower-right corner
            child: Image.asset(
              catImagePath,
              width: 150,
              height: 150,
            ),
          ),
          // Shop board with buttons
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Board image
                Image.asset(
                  'lib/assets/images/board.png',
                  width: 1050,
                  height: 1000,
                  fit: BoxFit.contain,
                ),
                // Buttons inside the board
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Food - 10 coins',
                      icon: Icons.fastfood,
                      color: Colors.orange,
                      onPressed: () => _confirmPurchase(context, coinProvider, 10, () {
                        coinProvider.buyFood(1); // Add 1 food to inventory
                      }),
                    ),
                    SizedBox(height: 16),
                    PixelButton(
                      label: 'Soap - 10 coins',
                      icon: Icons.soap,
                      color: Colors.blue,
                      onPressed: () => _confirmPurchase(context, coinProvider, 10, () {
                        coinProvider.buySoap(1); // Add 1 soap to inventory
                      }),
                    ),
                    SizedBox(height: 16),
                    PixelButton(
                      label: 'Medicine - 10 coins',
                      icon: Icons.medical_services,
                      color: Colors.red,
                      onPressed: () => _confirmPurchase(context, coinProvider, 10, () {
                        coinProvider.buyMedicine(1); // Add 1 medicine to inventory
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Back button
          Positioned(
            bottom: 16,
            left: 16,
            child: PixelButton(
              label: 'Back',
              icon: Icons.arrow_back,
              color: Color(0xFFFBBF65),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the pet screen
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase(BuildContext context, CoinProvider coinProvider, int cost, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFFFF6F71),
        title: Text(
          'Confirm Purchase',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to buy this item for $cost coins?',
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (coinProvider.inventory.getCoin() >= cost) {
                coinProvider.spendCoins(cost); // Deduct coins
                onSuccess(); // Add item to inventory
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Purchase successful!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Not enough coins!')),
                );
              }
            },
            child: Text(
              'Buy',
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
