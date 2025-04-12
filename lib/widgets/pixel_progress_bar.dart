import 'package:flutter/material.dart';

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
          children: List.generate(100, (index) {
            double segmentWidth = width / 100;
            return Container(
              width: segmentWidth,
              height: height,
              color: index / 100 < progress ? color : Colors.transparent,
            );
          }),
        ),
      ),
    );
  }
}