import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/gradientify.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const ProgressBar({super.key, this.progress = 1.0, this.height = 40.0});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return LayoutBuilder(
      builder: (context, contraints) {
        final color = progress > 1.0
            ? Colors.red.harmonizeWith(appState.primaryColor(context))
            : appState.primaryColor(context);
        return Stack(
          children: [
            Container(
              width: contraints.maxWidth * 0.9,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            Gradientify(
              gradient: LinearGradient(colors: [color , gradientPairColor(color)]),
              child: Container(
                width: progress > 1.0
                    ? contraints.maxWidth * 0.9
                    : contraints.maxWidth * 0.9 * progress,
              
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
            
          ],
        );
      },
    );
  }
}
