import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/flappy-components/ground.dart';
import 'package:pet_simulator/flappy-components/pipe.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  late Sprite upFlap;
  late Sprite midFlap;
  late Sprite downFlap;
  final String petType;

  // bird position and size 
  Bird({this.petType = 'cat'})
    : super(
        position: Vector2(birdStartX, birdStartY),
        size: Vector2(birdWidth, birdHeight),
      );

  // physical world properties
  double velocity = 0;
  double flapTimer = 0.0;

  // LOAD
  @override
  FutureOr<void> onLoad() async {
    // Load sprites based on pet type
    final type = petType.toLowerCase();
    upFlap = await Sprite.load('$type/bird_${type}_upflap.png');
    midFlap = await Sprite.load('$type/bird_${type}_midflap.png'); 
    downFlap = await Sprite.load('$type/bird_${type}_downflap.png');

    sprite = midFlap; // load bird sprite image
    add(RectangleHitbox()); // add hit box
  }

  // JUMP / FLAP
  void flap() {
    velocity = jumpStrength;
    sprite = downFlap;
    flapTimer = 0.0;
  }

  // UPDATE EVERY SECOND
  @override
  void update(double dt) {
    velocity += gravity * dt; // apply gravity
    position.y += velocity * dt;

    // Animate bird flap
    flapTimer += dt;
    if (flapTimer < 0.08) {
      sprite = upFlap;
    } else if (flapTimer < 0.16) {
      sprite = midFlap;
    } else if (flapTimer < 0.24) {
      sprite = downFlap;
    } else {
      flapTimer = 0.24; // stop incrementing
      sprite = upFlap;
    }
  }

  // COLLISION WITH ANOTHER OBJECT
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
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
