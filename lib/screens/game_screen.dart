import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;

  @override
  void initState() {
    super.initState();
    // Automatically reduce energy every 2 seconds while playing
    Future.delayed(Duration.zero, () async {
      while (mounted) {
        await Future.delayed(Duration(seconds: 2));
        Provider.of<PetProvider>(context, listen: false).playWithPet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: \$score'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  score += 10;
                  Provider.of<PetProvider>(context, listen: false).addCoins(5);
                });
              },
              child: Text('Tap to Score'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('End Game'),
            ),
          ],
        ),
      ),
    );
  }
}
