import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/pet_display.dart';
import 'game_screen.dart';
import 'shop_screen.dart';

class PixelButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color color;

  const PixelButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
    required this.color,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  void _updatePressed(bool pressed) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = _isPressed ? Offset(0, 0) : const Offset(4, 4);
    final bgColor = widget.isEnabled
        ? widget.color
        : widget.color.withOpacity(0.4);

    return GestureDetector(
      onTapDown: (_) => _updatePressed(true),
      onTapUp: (_) {
        _updatePressed(false);
        widget.onPressed?.call();
      },
      onTapCancel: () => _updatePressed(false),
      child: Stack(
        children: [
          if (!_isPressed && widget.isEnabled)
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(
                width: 110,
                height: 50,
                color: Colors.black,
              ),
            ),
          Container(
            width: 110,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 16, color: widget.isEnabled ? Colors.black : Colors.grey),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 6,
                    color: widget.isEnabled ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PixelProgressBar extends StatelessWidget {
  final double progress; // Value between 0 and 1
  final double width;
  final double height;
  final Color color;

  const PixelProgressBar({
    required this.progress,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(10, (index) {
            double segmentWidth = width / 10;
            return Container(
              width: segmentWidth,
              height: height,
              color: index / 10 <= progress ? color : Colors.transparent,
            );
          }),
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Pet',
          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/livingRoom3.png',
            fit: BoxFit.cover,
          ),
      
          SingleChildScrollView(
            child: Column(
              children: [
                // Hunger Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0), // Padding on left and right
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between label and progress bar
                    children: [
                      Text(
                        'Hunger:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8, // Pixel font style
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PixelProgressBar(
                        progress: petProvider.pet.getHunger() / 100,
                        width: 200, // You can adjust the width as needed
                        height: 20,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                // Energy Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
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

                CoinDisplay(),
                PetDisplay(),

                SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Feed',
                      icon: Icons.fastfood,
                      color: Colors.redAccent,
                      onPressed: () {
                        petProvider.feedPet();
                      }
                    ),
                    PixelButton(
                      label: 'Clean',
                      icon: Icons.bathtub,
                      color: Colors.blueAccent,
                      onPressed: petProvider.cleanPet,
                    ),
                    PixelButton(
                      label: 'Play',
                      icon: Icons.play_arrow,
                      color: Colors.purpleAccent,
                      onPressed: petProvider.playWithPet,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    PixelButton(
                      label: 'Shop',
                      icon: Icons.shopping_cart,
                      color: Colors.orangeAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopScreen()),
                      ),
                    ),
                    PixelButton(
                      label: 'Game',
                      icon: Icons.sports_esports,
                      color: Colors.pinkAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
