import 'package:flutter/material.dart';

class ProcessingPlaceholder extends StatelessWidget {
  final double? viewPortHeighRatio;
  const ProcessingPlaceholder({super.key, this.viewPortHeighRatio});

  @override
  Widget build(BuildContext context) {
    final inner = Column(
      mainAxisSize: viewPortHeighRatio == null ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: viewPortHeighRatio != null ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("En attente de traitement des données..."),
        ),
      ],
    );

    if (viewPortHeighRatio != null) {
      final height = MediaQuery.heightOf(context);
      return Center(
        child: SizedBox(height: height * viewPortHeighRatio!, child: inner,),
      );
    }

    return  inner;
  }
}
