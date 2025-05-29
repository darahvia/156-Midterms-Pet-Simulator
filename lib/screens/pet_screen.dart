import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pet_simulator/models/flappy-game.dart';
import 'package:pet_simulator/screens/flappy_bird_game_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/pet_display.dart';
import '../widgets/bubble.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_progress_bar.dart';
import '../services/music_manager.dart';
import 'tic_tac_toe_screen.dart';
import 'shop_screen.dart';
import 'vet_screen.dart';
import 'death_screen.dart';
import 'dart:math';

// UI for main pet screen
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final List<Widget> bubbles = [];
  final List<String> hearts = [
    'assets/images/heart_blue.gif',
    'assets/images/heart_orange.gif',
    'assets/images/heart_pink.gif',
    'assets/images/heart_purple.gif',
    'assets/images/heart_red.gif',
  ];
  String selectedFood = 'Feed';
  String selectedSoap = 'Clean';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final petProvider = Provider.of<PetProvider>(context);

    if (petProvider.death) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => DeathScreen("death")),
        );
      });
    }
  }

  void chooseGame(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Choose Game",
                      style: GoogleFonts.pressStart2p(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Tic Tac Toe',
                      icon: Icons.sports_esports,
                      color: Colors.pinkAccent,
                      onPressed: () {
                        Navigator.pop(context); // close dialog first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicTacToeScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    PixelButton(
                      label: 'Flappy Bird',
                      icon: Icons.sports_esports,
                      color: Colors.greenAccent,
                      onPressed: () {
                        Navigator.pop(context); // close dialog first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlappyBirdGameScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void addBubble({
    GlobalKey? key,
    Offset? position,
    required String imagePath,
  }) {
    double startLeft;
    double startBottom;

    if (key != null) {
      final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      final Offset widgetPosition = box.localToGlobal(Offset.zero);

      startLeft = widgetPosition.dx + box.size.width / 2 - 20;
      startBottom =
          MediaQuery.of(context).size.height -
          widgetPosition.dy -
          box.size.height / 2;
    } else if (position != null) {
      startLeft = position.dx - 20;
      startBottom = MediaQuery.of(context).size.height - position.dy;
    } else {
      throw ArgumentError('Either key or position must be provided');
    }

    final bubbleKey = UniqueKey();

    // Adds bubble object to bubbles list
    setState(() {
      bubbles.add(
        Bubble(
          key: bubbleKey,
          left: startLeft,
          bottom: startBottom,
          image: imagePath,
          onComplete: () {
            setState(() {
              bubbles.removeWhere((b) => b.key == bubbleKey);
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    // Button keys for tracking positions
    final GlobalKey feedButtonKey = GlobalKey();
    final GlobalKey cleanButtonKey = GlobalKey();
    final GlobalKey playButtonKey = GlobalKey();

    final Map<String, String> foodImages = {
      'Biscuit': 'assets/images/food_biscuit.png',
      'Can': 'assets/images/food_can.png',
      'Bag': 'assets/images/food_bag.png',
    };

    void chooseFeed(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Choose Feed",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PixelButton(
                        label: 'Biscuit',
                        icon: Icons.restaurant,
                        color: Colors.pinkAccent,
                        isEnabled:
                            coinProvider.inventory.getFood('biscuit') > 0,
                        onPressed:
                            coinProvider.inventory.getFood('biscuit') > 0
                                ? () {
                                  setState(() {
                                    selectedFood = 'Biscuit';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                      SizedBox(height: 5),
                      PixelButton(
                        label: 'Can',
                        icon: Icons.restaurant,
                        color: Colors.blueAccent,
                        isEnabled: coinProvider.inventory.getFood('can') > 0,
                        onPressed:
                            coinProvider.inventory.getFood('can') > 0
                                ? () {
                                  setState(() {
                                    selectedFood = 'Can';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                      SizedBox(height: 5),
                      PixelButton(
                        label: 'Bag',
                        icon: Icons.restaurant,
                        color: Colors.greenAccent,
                        isEnabled: coinProvider.inventory.getFood('bag') > 0,
                        onPressed:
                            coinProvider.inventory.getFood('bag') > 0
                                ? () {
                                  setState(() {
                                    selectedFood = 'Bag';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
    }

    final Map<String, String> soapImages = {
      'Wipes': 'assets/images/pet_wipes.png',
      'Soap': 'assets/images/pet_soap.png',
      'Shampoo': 'assets/images/pet_shampoo.png',
    };

    void chooseSoap(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Choose Soap",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PixelButton(
                        label: 'Wipes',
                        icon: Icons.restaurant,
                        color: Colors.pinkAccent,
                        isEnabled: coinProvider.inventory.getSoap('wipes') > 0,
                        onPressed:
                            coinProvider.inventory.getSoap('wipes') > 0
                                ? () {
                                  setState(() {
                                    selectedSoap = 'Wipes';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                      SizedBox(height: 5),
                      PixelButton(
                        label: 'Soap',
                        icon: Icons.restaurant,
                        color: Colors.blueAccent,
                        isEnabled: coinProvider.inventory.getSoap('soap') > 0,
                        onPressed:
                            coinProvider.inventory.getSoap('soap') > 0
                                ? () {
                                  setState(() {
                                    selectedSoap = 'Soap';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                      SizedBox(height: 5),
                      PixelButton(
                        label: 'Shampoo',
                        icon: Icons.restaurant,
                        color: Colors.greenAccent,
                        isEnabled:
                            coinProvider.inventory.getSoap('shampoo') > 0,
                        onPressed:
                            coinProvider.inventory.getSoap('shampoo') > 0
                                ? () {
                                  setState(() {
                                    selectedSoap = 'Shampoo';
                                  });
                                  MusicManager.playSoundEffect(
                                    'audio/button_tap.mp3',
                                  );
                                  Navigator.pop(context);
                                }
                                : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          petProvider.pet.getName(),
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
          Image.asset('assets/images/livingRoom.png', fit: BoxFit.cover),

          SingleChildScrollView(
            child: Column(
              children: [
                // Hunger Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hunger:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PixelProgressBar(
                        progress: petProvider.pet.getHunger() / 100,
                        width: 200,
                        height: 20,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                // Energy Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Energy:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PixelProgressBar(
                        progress: petProvider.pet.getEnergy() / 100,
                        width: 200,
                        height: 20,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                // Hygiene Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hygiene:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PixelProgressBar(
                        progress: petProvider.pet.getHygiene() / 100,
                        width: 200,
                        height: 20,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                // Happiness Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Happiness:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PixelProgressBar(
                        progress: petProvider.pet.getHappiness() / 100,
                        width: 200,
                        height: 20,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Showing petDisplay and handles tapping
                PetDisplay(
                  onTap: (tapPosition) {
                    addBubble(
                      position: tapPosition,
                      imagePath:
                          petProvider.pet.getPetState() != "sick"
                              ? (hearts[Random().nextInt(hearts.length)])
                              : ('assets/images/heart_broken.png'),
                    );
                  },
                ),

                // Pet interaction buttons
                SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    PixelButton(
                      label: selectedFood,
                      icon: Icons.restaurant,
                      color: Colors.redAccent,
                      key: feedButtonKey,
                      onHold: () => chooseFeed(context),
                      isEnabled:
                          petProvider.pet.getHunger() < 100 &&
                          (coinProvider.inventory.getFood('biscuits') > 0 ||
                              coinProvider.inventory.getFood('can') > 0 ||
                              coinProvider.inventory.getFood('bag') > 0),
                      onPressed:
                          coinProvider.inventory.getFood(
                                        selectedFood.toLowerCase(),
                                      ) >
                                      0 &&
                                  petProvider.pet.getHunger() < 100 &&
                                  petProvider.pet.getPetState() != "sick"
                              ? () {
                                MusicManager.playSoundEffect('audio/eat.mp3');
                                addBubble(
                                  key: feedButtonKey,
                                  imagePath: foodImages[selectedFood]!,
                                );
                                petProvider.feedPet(selectedFood.toLowerCase());
                                coinProvider.useItem(
                                  selectedFood.toLowerCase(),
                                );
                              }
                              : () {
                                MusicManager.playSoundEffect('audio/angry.mp3');
                                addBubble(
                                  key: feedButtonKey,
                                  imagePath: foodImages[selectedFood]!,
                                );
                                coinProvider.useItem(
                                  selectedFood.toLowerCase(),
                                );
                              },
                    ),
                    PixelButton(
                      label: selectedSoap,
                      icon: Icons.soap,
                      color: Colors.blueAccent,
                      key: cleanButtonKey,
                      onHold: () => chooseSoap(context),
                      isEnabled:
                          petProvider.pet.getHygiene() < 100 &&
                          (coinProvider.inventory.getSoap('wipes') > 0 ||
                              coinProvider.inventory.getSoap('soap') > 0 ||
                              coinProvider.inventory.getSoap('shampoo') > 0),
                      onPressed:
                          coinProvider.inventory.getSoap(
                                        selectedSoap.toLowerCase(),
                                      ) >
                                      0 &&
                                  petProvider.pet.getHygiene() < 100 &&
                                  petProvider.pet.getPetState() != "sick"
                              ? () {
                                MusicManager.playSoundEffect(
                                  'audio/bubbles.mp3',
                                );
                                addBubble(
                                  key: cleanButtonKey,
                                  imagePath: soapImages[selectedSoap]!,
                                );
                                petProvider.cleanPet(
                                  selectedSoap.toLowerCase(),
                                );
                                coinProvider.useItem(
                                  selectedSoap.toLowerCase(),
                                );
                              }
                              : () {
                                MusicManager.playSoundEffect('audio/angry.mp3');
                                addBubble(
                                  key: cleanButtonKey,
                                  imagePath: soapImages[selectedSoap]!,
                                );
                                coinProvider.useItem(
                                  selectedSoap.toLowerCase(),
                                );
                              },
                    ),
                    PixelButton(
                      label: 'Play',
                      icon: Icons.toys,
                      color: Colors.purpleAccent,
                      key: playButtonKey,
                      isEnabled:
                          petProvider.pet.getEnergy() > 10 &&
                          petProvider.pet.getHappiness() < 100,
                      onPressed:
                          petProvider.pet.getEnergy() > 10 &&
                                  petProvider.pet.getHappiness() < 100 &&
                                  petProvider.pet.getPetState() != "sick"
                              ? () {
                                MusicManager.playSoundEffect('audio/toy.mp3');
                                addBubble(
                                  key: playButtonKey,
                                  imagePath: 'assets/images/toy_mouse.png',
                                );
                                petProvider.playWithPet();
                              }
                              : () {
                                MusicManager.playSoundEffect('audio/angry.mp3');
                                addBubble(
                                  key: playButtonKey,
                                  imagePath: 'assets/images/toy_mouse.png',
                                );
                              },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Navigation buttons: Shop & Vet
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Shop',
                      icon: Icons.shopping_cart,
                      color: Colors.purpleAccent,
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopScreen(),
                            ),
                          ),
                    ),
                    PixelButton(
                      label: 'Vet',
                      icon: Icons.medical_services,
                      color: Colors.pinkAccent,
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VetScreen(),
                            ),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                PixelButton(
                  label: 'Games',
                  icon: Icons.sports_esports,
                  color: Colors.blueAccent,
                  onPressed: () => chooseGame(context),
                ),
              ],
            ),
          ),
          ...bubbles, // Renders bubbles list
        ],
      ),
    );
  }
}
