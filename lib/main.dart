import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'providers/coin_provider.dart';
import 'screens/start_screen.dart';
import 'services/music_manager.dart';
import '../services/local_storage.dart';


void main() {
  LocalStorage storage = LocalStorage(); //initialize local storage
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider(storage)),
        ChangeNotifierProvider(create: (_) => CoinProvider(storage)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MusicManager.playMusic(); // Start background music once
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  //music control when App not active
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      MusicManager.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      MusicManager.playMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
