class Game {
  int coins;

  //Tic Tac Toe board represented as a list of 9 strings (empty, X, or O)
  List<String> board;

  //The current player: "X" for the player, "O" for the computer
  String currentPlayer;

  //Winner of the game: "X", "O", or "Draw"
  String winner;

  //Constructor
  Game({
    this.coins = 0,
    List<String>? board,
    this.currentPlayer = "X", // Player starts first
    this.winner = "",
  }) : board =
           board ??
           List.filled(9, ""); //Initialize the board with empty strings

  //Reset the game
  void resetGame() {
    board = List.filled(9, ""); // Reset the board to empty
    currentPlayer = "X"; // Reset to player’s turn
    winner = ""; // No winner initially
  }
}
