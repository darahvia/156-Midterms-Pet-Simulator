import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';
import 'package:google_fonts/google_fonts.dart';

//handles coin display
class CoinDisplay extends StatelessWidget {
  const CoinDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/coin.png', 
          width: 24, 
          height: 24,
        ),
        SizedBox(width: 8), 
        Text(
          '${coinProvider.inventory.getCoin()}',
          style: GoogleFonts.pressStart2p(
            fontSize: 14, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
