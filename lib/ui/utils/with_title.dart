import 'package:flutter/material.dart';

class WithTitle extends StatelessWidget{
  final Widget child;
  final Widget title;
  final Widget? leading;
  final EdgeInsets titlePadding;
  const WithTitle({super.key, required this.child , required this.title , this.leading , this.titlePadding = const EdgeInsets.all(0.0)});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: titlePadding,
          child: Row(
            children: [
              ?leading,
              Flexible(child: title),
            ],
          ),
        ),
        child
      ],
    );
  }
}