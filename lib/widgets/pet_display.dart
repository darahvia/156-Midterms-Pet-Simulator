import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class PetDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    String imagePath = 'lib/assets/images/cat_normal.jpg';

    // if (petProvider.pet.hunger < 30) {
    //   imagePath = 'assets/images/cat_hungry.png';
    // } else if (petProvider.pet.hygiene < 30) {
    //   imagePath = 'assets/images/cat_dirty.png';
    // } else if (petProvider.pet.energy < 30) {
    //   imagePath = 'assets/images/cat_tired.png';
    // }

    return Stack(
      children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover),
        Center(child: Image.asset(imagePath, width: 150)),
      ],
    );
  }
}
