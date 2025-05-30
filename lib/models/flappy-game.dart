import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/flappy-components/background.dart';
import 'package:pet_simulator/flappy-components/bird.dart';
import 'package:pet_simulator/flappy-components/ground.dart';
import 'package:pet_simulator/flappy-components/pipe.dart';
import 'package:pet_simulator/flappy-components/pipe_manager.dart';
import 'package:pet_simulator/flappy-components/score.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pet_simulator/widgets/flappy_leaderboard_display.dart';
import 'package:pet_simulator/widgets/pixel_button.dart';
import 'package:provider/provider.dart';
import 'package:pet_simulator/providers/pet_provider.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  bool isPlaying = false;


  final BuildContext context;
  
  
  FlappyBirdGame(this.context);
  // LOAD
  @override
  FutureOr<void> onLoad() {
    // here ma initialize

    // load background
    background = Background(size);
    add(background);
    // load bird
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    bird = Bird(petType: petProvider.getPetType());
    add(bird);
    // load ground
    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);
  }

  // TAP
  @override
  void onTap() {
    bird.flap();
  }

  // SCORE
  int score = 0;
  int highScore = 0;
  void incrementScore() {
    score += 1;
  }

  void showLeaderboard() {
    if (buildContext == null) return;
    showDialog(
      context: buildContext!,
      builder: (context) => SizedBox(
        width: 400,
        height: 600,
        child: FlappyLeaderboard(),
      ),
    ).then((_) {
      // Resume game when leaderboard closes
      isGameOver = false;
      resumeEngine();
    });
  }

  // GAME OVER
  bool isGameOver = false;

  void gameOver() async {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    await _saveHighScore();
    await _addCoins();

    // Fetch high score from Firestore before showing dialog
    final user = FirebaseAuth.instance.currentUser;
    int fetchedHighScore = score;
    if (user != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await doc.get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('highScore')) {
        fetchedHighScore = snapshot.data()!['highScore'] ?? score;
      }
    }

    showDialog(
      context: buildContext!,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Center(
          child: Text(
            "Game Over",
            style: GoogleFonts.pressStart2p(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: $score",
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "High Score: $fetchedHighScore",
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PixelButton(
                  label: 'Restart',
                  icon: Icons.refresh,
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                ),
                const SizedBox(height: 12),
                PixelButton(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard,
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pop(context);
                    showLeaderboard();
                  },
                ),
                const SizedBox(height: 12),
                PixelButton(
                  label: 'End Game',
                  icon: Icons.exit_to_app,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop(); // Go back to pet screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHighScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // get current high score from Firestore
    final snapshot = await doc.get();
    int storedHighScore = 0;
    if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('highScore')) {
      storedHighScore = snapshot.data()!['highScore'] ?? 0;
    }

    // only update if the new high score is greater
    if (score > storedHighScore) {
      await doc.set({
        'highScore': score,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _addCoins() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snapshot = await doc.get();
    int currentCoins = 0;
    if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('inventoryData')) {
      final inventory = snapshot.data()!['inventoryData'] as Map<String, dynamic>?;
      if (inventory != null && inventory.containsKey('coin')) {
        currentCoins = inventory['coin'] ?? 0;
      }
    }

    // Add the score to the current coins
    final newCoins = currentCoins + score;

    await doc.update({
      'inventoryData.coin': newCoins,
    });
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    score = 0;
    children.whereType<Pipe>().forEach(
      (Pipe pipe) => pipe.removeFromParent(),
    ); // remove all pipes
    resumeEngine();
  }
}
