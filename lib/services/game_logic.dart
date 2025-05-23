import '../providers/coin_provider.dart';
import '../models/game.dart';
import '../services/music_manager.dart';
import 'dart:math'; // For generating random numbers

enum Difficulty { easy, medium, hard }

class GameLogic {
  final CoinProvider coinProvider;
  final Difficulty difficulty;
  late Game game;

  GameLogic(this.coinProvider, this.difficulty) {
    game = Game(); //initialize the game state
  }

  //handle player move
  bool playerMove(int index) {
    if (game.board[index] == "" && game.winner == "") {
      game.board[index] = "X"; // Player's move (X)
      MusicManager.playSoundEffect('audio/move.mp3');
      checkWinner(); // Check if player wins after the move
      return true; // Move was successful
    }
    return false; // Invalid move (spot is taken)
  }

  //handle computer move (O)
  Future<void> computerMove() async {
    if (game.winner != "") return;
    MusicManager.playSoundEffect('audio/move.mp3');

    if (difficulty == Difficulty.easy) {
      _randomMove(); // only random
    } else if (difficulty == Difficulty.medium) { //will prioritize winning conditions over random
      int? win = _findWinningMove("O");
      if (win != null) {
        game.board[win] = "O";
        checkWinner();
        return;
      }
      _randomMove();
    } else {  //will prioritize winning and block user win
      int? win = _findWinningMove("O");
      if (win != null) {
        game.board[win] = "O";
        checkWinner();
        return;
      }

      int? block = _findWinningMove("X");
      if (block != null) {
        game.board[block] = "O";
        checkWinner();
        return;
      }

      _randomMove();
    }
  }

  //handle random move
  void _randomMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == "") {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isNotEmpty) {
      Random random = Random();
      int randomIndex = availableMoves[random.nextInt(availableMoves.length)];
      game.board[randomIndex] = "O";
      checkWinner();
    }
  }

  //find if computer has a winning combination and return index that will complete it
  int? _findWinningMove(String symbol) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      String a = game.board[condition[0]];
      String b = game.board[condition[1]];
      String c = game.board[condition[2]];

      List<String> values = [a, b, c];
      int matchCount = values.where((v) => v == symbol).length;
      int emptyCount = values.where((v) => v == "").length;

      if (matchCount == 2 && emptyCount == 1) {
        for (int i in condition) {
          if (game.board[i] == "") {
            return i;
          }
        }
      }
    }

    return null;
  }

  // Check if a player has won the game
  void checkWinner() {
    // Define win conditions (rows, columns, diagonals)
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    // Check each win condition
    for (var condition in winConditions) {
      String a = game.board[condition[0]];
      String b = game.board[condition[1]];
      String c = game.board[condition[2]];

      if (a != "" && a == b && b == c) {
        game.winner = a;
        //reward coins if the player (X) wins
        if (game.winner == "X") {
          int reward = 0;
          switch (difficulty) {
            case Difficulty.easy:
              reward = 1;
              break;
            case Difficulty.medium:
              reward = 5;
              break;
            case Difficulty.hard:
              reward = 10;
              break;
          }
          coinProvider.addCoins(reward); // Add coins to the player's total
          MusicManager.playSoundEffect('audio/yay.mp3');
        } else {
          MusicManager.playSoundEffect('audio/boo.mp3');
        } //set the winner (either "X" or "O")
        return;
      }
    }

    //check if the game is a draw
    if (!game.board.contains("") && game.winner == "") {
      game.winner = "Draw";
    }
  }

  //reset the game
  void resetGame() {
    game.board = List.filled(9, ""); // Reset the board to empty
    game.currentPlayer = "X"; // Reset to player's turn (X)
    game.winner = ""; // No winner
  }
}
