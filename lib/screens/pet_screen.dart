import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../widgets/coin_display.dart';

class PetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Pet')),
      body: Column(
        children: [
          CoinDisplay(),
          Text('Hunger: ${petProvider.pet.hunger.toInt()}'),
          Text('Energy: ${petProvider.pet.energy.toInt()}'),
          Text('Hygiene: ${petProvider.pet.hygiene.toInt()}'),
          ElevatedButton(onPressed: petProvider.feedPet, child: Text('Feed')),
          ElevatedButton(
            onPressed: petProvider.playWithPet,
            child: Text('Play'),
          ),
          ElevatedButton(onPressed: petProvider.cleanPet, child: Text('Clean')),
        ],
      ),
    );
  }
}
