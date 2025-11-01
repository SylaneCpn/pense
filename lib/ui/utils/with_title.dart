import 'package:flutter/material.dart';

class WithTitle extends StatelessWidget{
  final Widget child;
  final String title;
  final TextStyle? style; 
  final TextAlign? textAlign;
  final EdgeInsetsGeometry padding ;  
  const WithTitle({super.key, required this.child , required this.title , this.style , this.textAlign, this.padding = EdgeInsetsGeometry.zero });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: Align(alignment: Alignment.centerLeft, child: Text(textAlign: textAlign, style : style , title)),
        ),
        child
      ],
    );
  }
}