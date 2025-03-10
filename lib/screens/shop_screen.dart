import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            coinProvider.spendCoins(20);
          },
          child: Text('Buy Food (20 Coins)'),
        ),
      ),
    );
  }
}
