import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pet_simulator/models/flappy-game.dart';
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
import 'shop_screen.dart';
import 'death_screen.dart';
import 'dart:math';

//ui for main pet screen
class VetScreen extends StatefulWidget {
  const VetScreen({super.key});

  @override
  _VetScreenState createState() => _VetScreenState();
}

class _VetScreenState extends State<VetScreen> {
  final List<Widget> bubbles = [];
  final List<String> hearts = [
    'assets/images/heart_blue.gif',
    'assets/images/heart_orange.gif',
    'assets/images/heart_pink.gif',
    'assets/images/heart_purple.gif',
    'assets/images/heart_red.gif',
  ];

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    //button keys for tracking positions
    final GlobalKey unquirkButtonKey = GlobalKey();
    final GlobalKey medicateButtonKey = GlobalKey();
    final GlobalKey rehomeButtonKey = GlobalKey();

    // handle creation of image bubbles with bubble animation 
    @override
    void addBubble({
      GlobalKey? key,
      Offset? position,
      required String imagePath,
    }) {
      double startLeft;
      double startBottom;

      if (key != null) {
        final RenderBox box =
            key.currentContext!.findRenderObject() as RenderBox;
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

      //adds bubble object to bubbles list
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
          Image.asset('assets/images/vet_background.png', fit: BoxFit.cover),

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
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween, // Space between label and progress bar
                    children: [
                      Text(
                        'Hunger:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8,
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
                          fontSize: 8,
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
                          fontSize: 8,
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
                          fontSize: 8,
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
                //showing petDisplay and handles tapping
                PetDisplay(
                  onTap: (tapPosition) {
                    addBubble(
                      position: tapPosition,
                      imagePath:
                          //creates heart bubbles when petDisplay is tapped
                          petProvider.pet.getPetState() != "sick"
                              ? (hearts[Random().nextInt(hearts.length)])//from hearts list
                              : ('assets/images/heart_broken.png'),//broken heart for when sick
                    );
                  },
                ),

                //pet interaction buttons
                SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    //change quirk of pet
                    PixelButton(
                      label: 'Unquirk',
                      icon: Icons.vaccines,
                      color: Colors.redAccent,
                      key: unquirkButtonKey,
                      onPressed: null,
                    ),
                    PixelButton(
                      label: 'Medicate',
                      icon: Icons.medication,
                      color: Colors.greenAccent,
                      key: medicateButtonKey,
                      onPressed: () {
                        MusicManager.playSoundEffect('audio/angry.mp3');
                        _confirmPurchase(context, coinProvider, 50, () {petProvider.healPet();}, "Do you want to fully heal your pet for 50 coins?");
                      },
                    ),
                    PixelButton(
                      label: 'Rehome',
                      icon: Icons.medication,
                      color: Colors.yellowAccent,
                      key: rehomeButtonKey,
                      onPressed: (){
                        MusicManager.playSoundEffect('audio/angry.mp3');
                        _confirmPurchase(context, coinProvider, 200, () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DeathScreen("rehomed")),
                          );
                        }, 
                        "Do you want to rehome your pet for 200 coins?");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                //navigation buttons: Shop & Game
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Shop',
                      icon: Icons.shopping_cart,
                      color: Colors.orangeAccent,
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopScreen(),
                            ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...bubbles, //renders bubbles list
        ],
      ),
      
    );
  }
  //handles purchases with confirmation query
  void _confirmPurchase(
    BuildContext context,
    CoinProvider coinProvider,
    int cost,
    VoidCallback onSuccess,
    String message,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Color(0xFFFF6F71),
            title: Text(
              'Confirm Purchase',
              style: GoogleFonts.pressStart2p(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (coinProvider.inventory.getCoin() >= cost) {
                    coinProvider.spendCoins(cost); // Deduct coins
                    onSuccess(); // Add item to inventory
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Received!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not enough coins!')),
                    );
                  }
                },
                child: Text(
                  'Pay',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
