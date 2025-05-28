import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'package:pet_simulator/models/flappy-game.dart';
import 'package:pet_simulator/widgets/coin_display.dart';

class FlappyBirdGameScreen extends StatelessWidget {
  const FlappyBirdGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = FlappyBirdGame();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Flappy Bird",
          style: GoogleFonts.pressStart2p(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CoinDisplay(), // Your coin widget
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GameWidget(game: game),
          ),
        ],
      ),
    );
  }
}
