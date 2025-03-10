import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class CoinDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.monetization_on, color: Colors.yellow),
        SizedBox(width: 5),
        Text(
          'Coins: ${coinProvider.game.coins}',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
