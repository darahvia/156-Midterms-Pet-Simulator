import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class PetDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mood = context.watch<PetProvider>().mood;

    String imagePath;

    // Decide on the image based on the mood
    if (mood == "dirty") {
      imagePath = 'lib/assets/images/cat_dirty.png';
    } else if (mood == "hungry") {
      imagePath = 'lib/assets/images/cat_hungry.png';
    } else if (mood == "tired") {
      imagePath = 'lib/assets/images/cat_tired.png';
    } else if (mood == "sad") {
      imagePath = 'lib/assets/images/cat_normal.png';
    } else {
      imagePath = 'lib/assets/images/cat_normal.png';
    }

    return Stack(
      children: [
        // Centered image with smooth transition using AnimatedSwitcher
        Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),  // Adjust duration for smoother/faster transition
            child: Image.asset(
              imagePath,
              key: ValueKey<String>(imagePath), // Ensures the image changes correctly
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
