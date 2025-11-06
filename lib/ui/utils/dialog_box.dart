import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatelessWidget{
  final double paddingPercent;
  final Widget? child;
  const DialogBox({super.key , this.paddingPercent = 0.05 , this.child});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final verticalPadding = constraints.maxHeight * paddingPercent;
        final horizontalPadding = constraints.maxWidth * paddingPercent;
        return Padding(
          padding: EdgeInsets.only(
            top: verticalPadding,
            bottom: verticalPadding,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Container(
            padding: EdgeInsets.only(left : verticalPadding, right: verticalPadding , top:  horizontalPadding , bottom: horizontalPadding ),
            decoration: BoxDecoration(
              color: appState.lightBackgroundColor(),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: child,
          ),
        );
      },
    );
  }
}