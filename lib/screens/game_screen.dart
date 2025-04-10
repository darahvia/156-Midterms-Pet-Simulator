import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_logic.dart';
import '../providers/coin_provider.dart';
import '../providers/pet_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  int score = 0;

  @override
  void initState() {
    super.initState();

    //initialize gameLogic and pass the CoinProvider to it
    gameLogic = GameLogic(Provider.of<CoinProvider>(context, listen: false));

    //auto-reduce energy or perform background action in PetProvider
    Future.delayed(Duration.zero, () async {
      while (mounted) {
        await Future.delayed(Duration(seconds: 2));
        //this simulates playing with the pet which affects energy
        Provider.of<PetProvider>(context, listen: false).playWithPet();
      }
    });
  }

  //handles player's move, updates score, and coins if they win
  void _handleTap(int index) {
    setState(() {
      final success = gameLogic.playerMove(index);
      if (success) {
        //if player wins (X), reward them with coins (5 coins)
        if (gameLogic.game.winner == "X") {
          Provider.of<PetProvider>(context, listen: false).addCoins(5);
          score += 1; // Update coins in game logic
        }
        if (gameLogic.game.winner == "O") {
          //if computer wins (O), deduct coins (2 coins)
          Provider.of<PetProvider>(context, listen: false).spendCoins(2);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = gameLogic.game;
    final coins =
        Provider.of<CoinProvider>(context).coins; // Fetch current coins

    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe Game"),
        actions: [
          // Display current coin count in the app bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(child: Text("Coins: $coins")),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game grid (Tic Tac Toe board)
          GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    game.currentPlayer == "X" &&
                            game.board[index] == "" &&
                            game.winner == ""
                        ? () => _handleTap(index) // Allow player to make a move
                        : null,
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      game.board[index], // Display X or O on the grid
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          // Show the winner or who's turn it is
          // Show the winner or who's turn it is
          Column(
            children: [
              Text(
                game.winner != ""
                    ? (game.winner == "Draw" ? "Draw" : "${game.winner} wins!")
                    : "Turn: ${game.currentPlayer}",
                style: TextStyle(fontSize: 24),
              ),
              if (game.winner != "")
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gameLogic.resetGame();
                    });
                  },
                  child: Text("Continue"),
                ),
            ],
          ),

          // Show the score that updates with each valid move
          Text("Score: $score", style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          // Button to reset the game
          SizedBox(height: 10),
          // Button to end the game and go back to the previous screen
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("End Game"),
          ),
        ],
      ),
    );
  }
}
