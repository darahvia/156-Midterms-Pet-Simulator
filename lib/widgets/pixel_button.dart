import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/music_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';

//button pixel design
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
    final bgColor =
        widget.isEnabled ? widget.color : widget.color.withOpacity(0.4);

    return GestureDetector(
      onTapDown: (_) => _updatePressed(true),
      onTapUp: (_) {
        _updatePressed(false);
        MusicManager.playSoundEffect('audio/button_tap.mp3');
        widget.onPressed?.call();
      },
      onTapCancel: () => _updatePressed(false),
      child: Stack(
        children: [
          if (!_isPressed && widget.isEnabled)
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(width: 110, height: 50, color: Colors.black),
            ),
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.all(3.0),
                child: Icon(
                    widget.icon,
                    size: 16,
                    color: widget.isEnabled ? Colors.black : Colors.grey,
                  ),
                ),
                Expanded( // Make sure it can shrink
                  child: AutoSizeText(
                    widget.label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 15,
                      color: widget.isEnabled ? Colors.black : Colors.grey,
                    ),
                    minFontSize: 2,
                    overflow: TextOverflow.ellipsis,
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
