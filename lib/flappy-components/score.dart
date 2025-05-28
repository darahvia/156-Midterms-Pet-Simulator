import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class ScoreText extends TextComponent with HasGameRef<FlappyBirdGame> {
  ScoreText() : super(text: '0', textRenderer: TextPaint(style:TextStyle(color: Colors.black, fontSize: 48)));

  // load
  @override
  FutureOr<void> onLoad() {
    // set position to lower middle
    position = Vector2(
      // center horizontally
      (gameRef.size.x - size.x) / 2,
      // slightly above the bottom
      gameRef.size.y - size.y - 50,
    );
  }

  // update
  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
