import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../services/music_manager.dart';

//controls pet display
class PetDisplay extends StatelessWidget {
  final void Function(Offset tapPosition)? onTap;

  const PetDisplay({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<PetProvider>().mood;
    final petProvider = context.read<PetProvider>();

    String imagePath;

    // Decide on the image based on the mood
    if (petProvider.pet.getIsSick() == true) {
      imagePath = 'assets/images/cat_sick.png';
    } else if (mood == "dirty") {
      imagePath = 'assets/images/cat_dirty.png';
    } else if (mood == "hungry") {
      imagePath = 'assets/images/cat_hungry.png';
    } else if (mood == "tired") {
      imagePath = 'assets/images/cat_tired.png';
    } else if (mood == "sad") {
      imagePath = 'assets/images/cat_normal.png';
    } else {
      imagePath = 'assets/images/cat_happy.png';
    }

    //handles tapping on pet display
    return GestureDetector(
      onTapDown: (details) {
        if (onTap != null) {
          if(mood != "sick"){
            MusicManager.playSoundEffect('audio/meow.mp3');
            petProvider.poke();
          } else{
            MusicManager.playSoundEffect('audio/angry_meow.mp3');
            petProvider.poke();
          }

          onTap!(details.globalPosition);
        }
      },
      child: Center(
        child: AnimatedSwitcher( //animation for fading between image change
          duration: Duration(milliseconds: 500),
          child: Image.asset(
            imagePath,
            key: ValueKey<String>(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
