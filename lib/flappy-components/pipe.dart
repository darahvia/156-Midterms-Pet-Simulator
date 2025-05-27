import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlappyBirdGame> {
  final bool isTopPipe; // determine if pipe is top or bottom
  bool scored = false;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
    : super(position: position, size: size);

  // LOAD

  @override
  FutureOr<void> onLoad() async {
    // load sprite image pipe
    sprite = await Sprite.load(isTopPipe ? 'pipe-top.png' : 'pipe-bottom.png');

    // add hitbox for collision
    add(RectangleHitbox());
  }

  // UPDATE
  @override
  void update(double dt) {
    // scroll pipe to the left
    position.x -= groundScrollingSpeed * dt;
    // check if the bird has passed the pipe
    if (!scored && position.x + size.x < gameRef.bird.position.x) {
      scored = true;
      if (isTopPipe) {
        gameRef.incrementScore();
      }
    }
    // remove pipe if it goes off from screen
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
