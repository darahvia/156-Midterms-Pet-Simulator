class Game {
  //Tic Tac Toe board represented as a list of 9 strings (empty, X, or O)
  List<String> board;
  String currentPlayer;
  String winner;

  Game({
    List<String>? board,
    this.currentPlayer = "X", // Player starts first
    this.winner = "",
  }) : board =
           board ??
           List.filled(9, ""); //Initialize the board with empty strings

  //Reset the game
  void resetGame() {
    board = List.filled(9, ""); 
    currentPlayer = "X"; 
    winner = ""; 
  }
}
