import 'package:flutter/material.dart';

class TextAddButton extends StatelessWidget {
  const TextAddButton({super.key , this.onPressed , required this.text, this.backgroundColor,this.textColor});

  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final  String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
                style: TextButton.styleFrom(backgroundColor: backgroundColor),
                onPressed: onPressed,
                child: Text(style : TextStyle(color: textColor), "+ $text"),
              );
  }
} 