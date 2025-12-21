import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget{
  final Color color;
  final double radius;
  const ColorCircle({super.key , required this.color , this.radius = 100.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius/2,
      height: radius/2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle
      ),
    );
  }
}