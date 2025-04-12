import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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