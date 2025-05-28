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
    final petType = petProvider.pet.getType().toLowerCase();

    String imagePath;

    // Decide on the image based on the mood
    if (petProvider.pet.getIsSick() == true) {
    imagePath = 'assets/images/$petType/${petType}_sick.png';
  } else if (mood == "dirty") {
    imagePath = 'assets/images/$petType/${petType}_dirty.png';
  } else if (mood == "hungry") {
    imagePath = 'assets/images/$petType/${petType}_hungry.png';
  } else if (mood == "tired") {
    imagePath = 'assets/images/$petType/${petType}_tired.png';
  } else if (mood == "sad") {
    imagePath = 'assets/images/$petType/${petType}_normal.png';
  } else {
    imagePath = 'assets/images/$petType/${petType}_happy.png';
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher( //animation for fading between image change
              duration: Duration(milliseconds: 500),
              child: Image.asset(
                imagePath,
                key: ValueKey<String>(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            if (petProvider.currentClothing != null)
              Image.asset(
                'assets/images/${petProvider.currentClothing}_${mood}.png',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/${petProvider.currentClothing}.png',
                    width: 200,
                    height: 200,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
