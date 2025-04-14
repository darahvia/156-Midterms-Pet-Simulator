import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pixel_button.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/coin_provider.dart';
import 'dart:io';
import 'start_screen.dart';

class DeathScreen extends StatelessWidget {
  const DeathScreen({Key? key}) : super(key: key);

  Future<void> _deleteAllData(BuildContext context) async {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    print("All files deleted and local storage disabled.");

    final directory = await getApplicationDocumentsDirectory();
    directory.listSync().forEach((file) {
      if (file is File) file.deleteSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Game Over',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/dead_bg.png', fit: BoxFit.cover),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300),
                Text(
                  '${petProvider.pet.getName()} passed away',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Cat picture
                Image.asset(
                  'assets/images/cat_dead.png',
                  height: 150,
                  width: 500,
                ),
                const SizedBox(height: 20),
                PixelButton(
                  label: 'Main Menu',
                  icon: Icons.home,
                  color: Colors.redAccent,
                  onPressed: () async {
                    print('Pet Name: ${petProvider.pet.getName()}');
                    print('Hunger: ${petProvider.pet.getHunger()}');
                    print('Happiness: ${petProvider.pet.getHappiness()}');
                    print('Energy: ${petProvider.pet.getEnergy()}');
                    print('Hygiene: ${petProvider.pet.getHygiene()}');
                    print('Inventory:');
                    print('Coins: ${coinProvider.inventory.getCoin()}');
                    print('Food: ${coinProvider.inventory.getFood()}');
                    print('Soap: ${coinProvider.inventory.getSoap()}');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => StartScreen(),
                      ), // Replace with your start screen widget
                      (route) => false, // Remove all previous routes
                    );
                    await _deleteAllData(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
