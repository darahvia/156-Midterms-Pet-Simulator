import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  final double left;
  final double bottom;
  final VoidCallback onComplete;
  final String image;

  //handles creation of bubble images with animation in given position
  const Bubble({
    super.key,
    required this.left,
    required this.bottom,
    required this.onComplete,
    required this.image,
  });

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _riseAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    //movement
    _riseAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    //fading
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.left,
          bottom: widget.bottom + _riseAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        widget.image,
        width: 100,
        height: 100,
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
