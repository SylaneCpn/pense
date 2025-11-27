import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class InvalidRange  extends StatelessWidget{
  const InvalidRange({super.key});

  @override
  Widget build(BuildContext context) {
    final appState =  context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedContainer(
        decoration: BoxDecoration(
            color: appState.lessContrastBackgroundColor(),
          ),
          borderRadius: BorderRadius.circular(8.0),
          elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentGeometry.center,
                child: Text(
                  "Plage invalide.",
                  style: TextStyle(
                    fontSize: PortView.mediumTextSize(MediaQuery.sizeOf(context).width),
                    color: appState.onLessContrastBackgroundColor(),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.center,
                child: Text(
                  "La date de fin est plus récente que la date de début. Sélectionnez une plage valide.",
                  style: TextStyle(
                    fontSize: PortView.regularTextSize(
                      MediaQuery.sizeOf(context).width,
                    ),
                    color: appState.onLessContrastBackgroundColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}