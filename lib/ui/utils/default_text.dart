import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget{
  final String missing;
  final Color? textColor;
  const DefaultText({super.key ,required this.missing , this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Pas de $missing disponible.", style: TextStyle(fontSize: 24.0,color: textColor),),
        Text("Ajoutez des élements pour les voir apparaire." , style:  TextStyle(color: textColor),)
      ],
    );
  }
}