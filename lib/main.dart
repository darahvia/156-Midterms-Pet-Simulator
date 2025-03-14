import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'providers/coin_provider.dart';
import 'screens/pet_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => CoinProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetProvider(),
      child: MaterialApp(
        home: PetScreen(),
      ),
    );
  }
}
