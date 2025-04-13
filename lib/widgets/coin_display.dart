import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class CoinDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Text(
      'Coins: ${coinProvider.inventory.getCoin()}',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
