import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../services/music_manager.dart';

class PetDisplay extends StatelessWidget {
  final void Function(Offset tapPosition)? onTap;

  const PetDisplay({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<PetProvider>().mood;
    final petProvider = context.read<PetProvider>();

    String imagePath;

    // Decide on the image based on the mood
    if (mood == "dirty") {
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

    return GestureDetector(
      onTapDown: (details) {
        if (onTap != null) {
          MusicManager.playSoundEffect('audio/meow.mp3');
          petProvider.poke();
          onTap!(details.globalPosition);
        }
      },
      child: Center(
        child: AnimatedSwitcher(
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
