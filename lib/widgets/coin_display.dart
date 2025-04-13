import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/coin.png', // Path to your coin image
          width: 24, // Adjust the size of the image
          height: 24,
        ),
        SizedBox(width: 8), // Add some spacing between the image and text
        Text(
          '${coinProvider.inventory.getCoin()}',
          style: GoogleFonts.pressStart2p(
            fontSize: 14, // Adjust the font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
