import '../providers/coin_provider.dart';
import '../models/game.dart';
import 'dart:math'; // For generating random numbers

class GameLogic {
  final CoinProvider coinProvider;
  late Game game;

  GameLogic(this.coinProvider) {
    game = coinProvider.game; // Initialize game with data from CoinProvider
  }

  // Handle player move
  bool playerMove(int index) {
    if (game.board[index] == "" && game.winner == "") {
      game.board[index] = "X"; // Player's move (X)
      checkWinner(); // Check if player wins after the move
      if (game.winner == "") {
        computerMove(); // If no winner, the computer will play next
      }
      return true; // Move was successful
    }
    return false; // Invalid move (spot is taken)
  }

  // Handle computer move (O)
  void computerMove() {
    if (game.winner != "") return; // Don't make a move if the game is over

    int? winningMove = _findWinningMove("O");
    if (winningMove != null) {
      game.board[winningMove] = "O";
      checkWinner();
      return;
    }

    // Computer try to block player from winning
    int? blockingMove = _findWinningMove("X");
    if (blockingMove != null) {
      game.board[blockingMove] = "O";
      checkWinner();
      return;
    }

    // Find available spots
    List<int> availableMoves = [];
    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == "") {
        availableMoves.add(i);
      }
    }

    // Computer makes a random move in an empty spot
    if (availableMoves.isNotEmpty) {
      Random random = Random();
      int randomIndex = availableMoves[random.nextInt(availableMoves.length)];
      game.board[randomIndex] = "O"; // Computer's move (O)
      checkWinner(); // Check if computer wins after the move
      return;
    }
  }

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
        game.winner = a; // Set the winner (either "X" or "O")
        return;
      }
    }

    // Check if the game is a draw
    if (!game.board.contains("") && game.winner == "") {
      game.winner = "Draw";
    }
  }

  // Reset the game
  void resetGame() {
    game.board = List.filled(9, ""); // Reset the board to empty
    game.currentPlayer = "X"; // Reset to player's turn (X)
    game.winner = ""; // No winner
    coinProvider.addCoins(0);
  }
}
