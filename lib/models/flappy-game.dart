import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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


class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;

  // LOAD
  @override
  FutureOr<void> onLoad() {
    // here ma initialize

    // load background
    background = Background(size);
    add(background);
    // load bird
    bird = Bird();
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

  @override
  void onRemove() {
    _saveHighScore();
    super.onRemove();
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
    );
  }

  // GAME OVER
  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    // show dialog box
    showDialog(
      context: buildContext!,
      builder:
          (context) => AlertDialog(
            title: const Text("Game Over"),
            content: Text("High Score: $score "),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: const Text("Restart"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showLeaderboard();
                },
                child: const Text("Leaderboard"),
              ),
            ],
          ),
    );
  }

  Future<void> _saveHighScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    await doc.set({
      'username': user.displayName ?? user.email ?? 'Anonymous',
      'highScore': highScore,
    }, SetOptions(merge: true));
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
