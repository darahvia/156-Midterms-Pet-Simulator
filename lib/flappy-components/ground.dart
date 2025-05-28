import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class Ground extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  // init
  Ground() : super();

  // LOAD

  @override
  FutureOr<void> onLoad() async {
    // set size and position (2x width for infinite scroll)
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - groundHeight);

    // load ground sprite image
    sprite = await Sprite.load('ground.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // move ground to the left
    position.x -= groundScrollingSpeed * dt;

    // reset ground if it goes off screen  (infinite scroll)
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
  }
}
