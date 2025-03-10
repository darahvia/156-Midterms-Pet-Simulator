import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveCoins(int coins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('coins', coins);
  }

  static Future<int> getCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('coins') ?? 0;
  }
}
