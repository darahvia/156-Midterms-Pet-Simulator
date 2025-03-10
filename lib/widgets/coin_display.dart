import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class CoinDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Text(
      'Coins: ${petProvider.pet.coins}',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
