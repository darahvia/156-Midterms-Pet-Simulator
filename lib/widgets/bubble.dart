import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  final Offset startOffset;
  final VoidCallback onComplete;

  const Bubble({required this.startOffset, required this.onComplete});

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: widget.startOffset,
      end: Offset(widget.startOffset.dx, widget.startOffset.dy - 200), // Bubble moves up
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(begin: 1, end: 0).animate(_controller); // Fade out the bubble

    _controller.forward().then((_) {
      widget.onComplete(); // Call onComplete after animation
      print('Animation completed');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          left: 100, // Fixed position
          top: 100,
          child: Opacity(
            opacity: _fade.value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
  }
}