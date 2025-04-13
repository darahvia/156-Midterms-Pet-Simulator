import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pixel_button.dart';

class DeathScreen extends StatelessWidget {
  const DeathScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
                // Cat picture
                Image.asset(
                  'assets/images/cat_dead.png',
                  height: 300,
                  width: 300,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Text(
                  '${petProvider.pet.getName()} passed away',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PixelButton(
                  label: 'Main Menu',
                  icon: Icons.home,
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(); // Navigate back to the previous screen
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
