import 'package:flutter/material.dart';

class ProcessingRecord extends StatelessWidget {
  const ProcessingRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text("En attente de traitement des données"),
        ],
      ),
    );
  }
}
