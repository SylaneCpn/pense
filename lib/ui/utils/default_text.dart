import 'package:flutter/material.dart';
import 'package:pense/ui/utils/port_view.dart';

class DefaultText extends StatelessWidget{
  final String missing;
  final Color? textColor;
  const DefaultText({super.key ,required this.missing , this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Pas de $missing disponible.", style: TextStyle(fontSize: PortView.mediumTextSize(MediaQuery.sizeOf(context).width),color: textColor),),
        Text("Ajoutez des élements pour les voir apparaire." , style:  TextStyle(fontSize: PortView.regularTextSize(MediaQuery.sizeOf(context).width), color: textColor),)
      ],
    );
  }
}