import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/flappy-components/ground.dart';
import 'package:pet_simulator/flappy-components/pipe.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  // bird position and size
  Bird()
    : super(
        position: Vector2(birdStartX, birdStartY),
        size: Vector2(birdWidth, birdHeight),
      );

  // physical world properties
  double velocity = 0;

  // LOAD
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(
      'yellowbird-midflap.png',
    ); // load bird sprite image
    add(RectangleHitbox()); // add hit box
  }

  // JUMP / FLAP
  void flap() {
    velocity = jumpStrength;
  }

  // UPDATE EVERY SECOND
  @override
  void update(double dt) {
    velocity += gravity * dt; // apply gravity
    position.y += velocity * dt;
  }

  // COLLISION WITH ANOTHER OBJECT
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    // check if bird collides with ground
    if (other is Ground) {
      (parent as FlappyBirdGame).gameOver();
    }

    // check if bird collides with pipes
    if (other is Pipe) {
      (parent as FlappyBirdGame).gameOver();
    }
  }
}
