import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class SwitchLabel extends StatelessWidget{
  final String label;
  final bool disabled;
  final bool toWatchFlag;
  final void Function() toogleToWatchFlagCallback;
  const SwitchLabel({super.key, required this.label, required this.toWatchFlag , required this.toogleToWatchFlagCallback, this.disabled = false});

  TextStyle _textStyle(AppState appState , BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context))
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
            children: [
              Expanded(child: Text(label ,style: _textStyle(appState, context),)),
              Switch(value: toWatchFlag, onChanged: disabled ? null : (_) => toogleToWatchFlagCallback(),)
            ],
          ),
    );
  }

}

