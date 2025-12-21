import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:provider/provider.dart';

class DecoratedGradientTitle extends StatelessWidget {
  final String label;
  final double borderRadius;
  final EdgeInsets innerPadding;

  const DecoratedGradientTitle({
    super.key,
    this.borderRadius = 24.0,
    this.innerPadding = const EdgeInsets.all(8.0),
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return ElevatedContainer(
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: innerPadding,
        child: GradientTitle(label: label),
      ),
    );
  }
}
