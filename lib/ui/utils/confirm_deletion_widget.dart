import 'package:flutter/material.dart';

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
    return AlertDialog(
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
