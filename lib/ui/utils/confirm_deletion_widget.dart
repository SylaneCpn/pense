import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:provider/provider.dart';

class ConfirmDeletionWidget extends StatelessWidget {
  final void Function() onDeleteCallBack;
  final String title;

  const ConfirmDeletionWidget({
    super.key,
    required this.onDeleteCallBack,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return AlertDialog(
      backgroundColor: appState.lightBackgroundColor(),
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Retour"),
        ),
        TextButton(
          onPressed: () {
            onDeleteCallBack();
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        ),
      ],
    );
  }
}
