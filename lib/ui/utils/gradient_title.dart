import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/gradientify.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class GradientTitle extends StatelessWidget{
  final String label;

  const GradientTitle({super.key, required this.label});
  
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final labelColor = appState.primaryColor(context); 
    return Gradientify(
              gradient: LinearGradient(
                colors: [labelColor, gradientPairColor(labelColor)],
              ),
              child: Text(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: PortView.doubleRegularTextSize(
                    MediaQuery.sizeOf(context).width,
                  ),
                ),
                label,
              ),
            );
  }
}