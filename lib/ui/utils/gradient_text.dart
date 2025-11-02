import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final Text text;
  final Gradient gradient;
  const GradientText({super.key, required this.text, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: text,
    );
  }
}
