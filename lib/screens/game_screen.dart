import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Play Game')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            coinProvider.addCoins(10);
          },
          child: Text('Earn 10 Coins'),
        ),
      ),
    );
  }
}
