// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import 'game_screen.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

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
                  '${petProvider.pet.coins} Coins',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
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
                  width: 850,
                  height: 850,
                  fit: BoxFit.contain,
                ),
                // Buttons inside the board
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShopItem(
                      context,
                      title: 'Food - 10 coins',
                      imagePath: 'assets/images/cat_food_bag.png',
                      onBuy: () => _confirmPurchase(context, petProvider, coinProvider, 10, petProvider.feedPet),
                    ),
                    SizedBox(height: 16),
                    _buildShopItem(
                      context,
                      title: 'Toy - 15 coins',
                      imagePath: 'assets/images/toy_mouse.png',
                      onBuy: () => _confirmPurchase(context, petProvider, coinProvider, 15, petProvider.playWithPet),
                    ),
                    SizedBox(height: 16),
                    _buildShopItem(
                      context,
                      title: 'Medicine - 20 coins',
                      imagePath: 'assets/images/medicine.png',
                      onBuy: () => _confirmPurchase(context, petProvider, coinProvider, 20, petProvider.cleanPet),
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
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the pet screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFBBF65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.pressStart2p(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Game button
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6FCF97),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Play Game',
                style: GoogleFonts.pressStart2p(
                  fontSize: 16,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, {required String title, required String imagePath, required VoidCallback onBuy}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFFFBBF65),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFBBF65),
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
          ),
          SizedBox(height: 4),
          TextButton(
            onPressed: onBuy,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
              title,
              style: GoogleFonts.pressStart2p(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase(BuildContext context, PetProvider petProvider, CoinProvider coinProvider, int cost, VoidCallback onSuccess) {
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
              if (petProvider.pet.coins >= cost) {
                coinProvider.spendCoins(cost);
                onSuccess();
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
