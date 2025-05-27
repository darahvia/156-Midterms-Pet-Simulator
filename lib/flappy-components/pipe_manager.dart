import 'dart:math';

import 'package:flame/components.dart';
import 'package:pet_simulator/constants.dart';
import 'package:pet_simulator/flappy-components/pipe.dart';
import 'package:pet_simulator/models/flappy-game.dart';

class PipeManager extends Component with HasGameRef<FlappyBirdGame> {
  // continuously spawn pipes

  double pipeSpawnTimer = 0;
  @override
  void update(double dt) {
    pipeSpawnTimer += dt;

    if (pipeSpawnTimer > pipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  // SPAWN PIPE
  void spawnPipe() {
    final double screenHeight = gameRef.size.y;

    // CALCULATE PIPE HEIGHTS

    // max possible height
    final double maxPipeHeight =
        screenHeight - groundHeight - pipeGap - minPipeHeight;

    // height of bottom pipe, select between min and max
    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);

    // height of top pipe
    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    // CREATE BOTTOM PIPE
    final bottomPipe = Pipe(
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    // CREATE TOP PIPE
    final topPipe = Pipe(
      Vector2(gameRef.size.x, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );
    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }
}
