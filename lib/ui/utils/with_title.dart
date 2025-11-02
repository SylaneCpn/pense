import 'package:flutter/material.dart';

class WithTitle extends StatelessWidget{
  final Widget child;
  final Widget title; 
  final AlignmentGeometry titleAlignment;
  const WithTitle({super.key, required this.child , required this.title , this.titleAlignment = AlignmentGeometry.center});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: titleAlignment, child: title),
        child
      ],
    );
  }
}