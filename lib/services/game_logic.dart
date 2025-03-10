import '../providers/coin_provider.dart';

class GameLogic {
  final CoinProvider coinProvider;

  GameLogic(this.coinProvider);

  void playGame() {
    coinProvider.addCoins(10);
  }
}
