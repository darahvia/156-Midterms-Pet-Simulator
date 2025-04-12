// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/pet_display.dart';
import '../widgets/bubble.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_progress_bar.dart';
import '../services/music_manager.dart';
import 'game_screen.dart';
import 'shop_screen.dart';
import 'dart:math';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

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
                  width: 850, // Increased width
                  height: 850, // Increased height
                  fit: BoxFit.contain,
                ),
                // Buttons inside the board
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShopItem(
                      context,
                      title: 'Food - 10 coins',
                      imagePath: 'lib/assets/images/food.png',
                      onBuy: () => _confirmPurchase(context, petProvider, 10, petProvider.feedPet),
                    ),
                    SizedBox(height: 16), // Space between buttons
                    _buildShopItem(
                      context,
                      title: 'Toy - 15 coins',
                      imagePath: 'lib/assets/images/toy.png',
                      onBuy: () => _confirmPurchase(context, petProvider, 15, petProvider.playWithPet),
                    ),
                    SizedBox(height: 16), // Space between buttons
                    _buildShopItem(
                      context,
                      title: 'Medicine - 20 coins',
                      imagePath: 'lib/assets/images/medicine.png',
                      onBuy: () => _confirmPurchase(context, petProvider, 20, petProvider.cleanPet),
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
                backgroundColor: Color(0xFFFBBF65), // Match button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No border radius
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
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, {required String title, required String imagePath, required VoidCallback onBuy}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: 150,
      height: 80, // Adjusted height to fit image and text
      decoration: BoxDecoration(
        color: Color(0xFFFBBF65), // Button color
        border: Border.all(color: Colors.black, width: 2), // Black border
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFBBF65),
            offset: Offset(4, 4), // Shadow position
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
              padding: EdgeInsets.zero, // Remove default padding
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

  void _confirmPurchase(BuildContext context, PetProvider petProvider, int cost, VoidCallback onSuccess) {
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
                petProvider.spendCoins(cost);
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
