import 'package:flutter/material.dart';

class GradientChip extends StatelessWidget {
  final Color start;
  final Color end;
  final double width;
  final double height;
  final double borderRadius;

  const GradientChip({
    super.key,
    required this.start,
    required this.end,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
