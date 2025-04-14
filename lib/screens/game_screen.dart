import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_logic.dart';
import '../providers/coin_provider.dart';
import '../widgets/pixel_button.dart';
//import '../providers/pet_provider.dart';
import '../widgets/coin_display.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  int score = 0;
  Difficulty selectedDifficulty = Difficulty.easy;
  bool isComputerMoving = false;

  @override
  void initState() {
    super.initState();

    //initialize gameLogic and pass the CoinProvider to it
    gameLogic = GameLogic(
      Provider.of<CoinProvider>(context, listen: false),
      selectedDifficulty,
    );
  }

  void _handleTap(int index) async {
    if (isComputerMoving) return;
    bool moved = gameLogic.playerMove(index); // do not await here

    if (moved) {
      setState(() {}); // show player's move right away

      // now wait for computer move
      isComputerMoving = true;
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // slight delay to allow UI update
      await gameLogic.computerMove();
      setState(() {
        isComputerMoving = false;
      }); // show computer's move
    }
  }

  void _changeDifficulty(Difficulty diff) {
    setState(() {
      selectedDifficulty = diff;
      gameLogic = GameLogic(
        Provider.of<CoinProvider>(context, listen: false),
        selectedDifficulty,
      );
      gameLogic.resetGame(); //reset the game when difficulty changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = gameLogic.game;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Tic Tac Toe",
          style: GoogleFonts.pressStart2p(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Display current coin count in the app bar
          Padding(padding: const EdgeInsets.all(12.0), child: CoinDisplay()),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/gameRoom.png', fit: BoxFit.cover),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 8,
                //difficulty selection buttons
                children:
                    Difficulty.values.map((diff) {
                      Color buttonColor;
                      switch (diff) {
                        case Difficulty.easy:
                          buttonColor = Colors.green;
                          break;
                        case Difficulty.medium:
                          buttonColor = Colors.yellow;
                          break;
                        case Difficulty.hard:
                          buttonColor = Colors.blue;
                          break;
                      }

                      return PixelButton(
                        label: diff.name.toUpperCase(),
                        icon: Icons.videogame_asset,
                        color: buttonColor,
                        isEnabled: selectedDifficulty != diff,
                        onPressed: () => _changeDifficulty(diff),
                      );
                    }).toList(),
              ),

              SizedBox(height: 10),
              // Game grid (Tic Tac Toe board)
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/board.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GridView.builder(
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
                              ? () => _handleTap(
                                index,
                              ) // Allow player to make a move
                              : null,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Center(
                          child:
                              game.board[index] == "X"
                                  ? SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset('assets/images/X.png'),
                                  )
                                  : game.board[index] == "O"
                                  ? SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset('assets/images/O.png'),
                                  )
                                  : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Show the winner or who's turn it is
              Column(
                children: [
                  Text(
                    game.winner != ""
                        ? (game.winner == "Draw"
                            ? "Draw"
                            : "${game.winner} wins!")
                        : "",
                    style: GoogleFonts.pressStart2p(
                      fontSize: 14, // Adjust the font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              // Button to end the game and go back to the previous screen
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  PixelButton(
                    label: 'Continue',
                    icon: Icons.exit_to_app,
                    color: Colors.greenAccent,
                    isEnabled: game.winner != "",
                    onPressed:
                        game.winner != ""
                            ? () {
                              setState(() {
                                gameLogic.resetGame();
                              });
                            }
                            : null,
                  ),
                  PixelButton(
                    label: 'End Game',
                    icon: Icons.exit_to_app,
                    color: Colors.redAccent,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
