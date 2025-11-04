import 'package:flutter/material.dart';

class Gradientify extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  const Gradientify({super.key,required this.gradient,required this.child,});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: child,
    );
  }
}
