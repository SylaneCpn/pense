import 'package:flutter/material.dart';

class Accordition extends StatefulWidget{
  final Widget header;
  final Widget child;
  final BoxDecoration? decoration;
  final double width;

  const Accordition({super.key , required this.header , required this.child, this.decoration , required this.width });
  
  @override
  State<Accordition> createState() => _AccorditionState();
}

class _AccorditionState extends State<Accordition> {

  bool _collapsed = false;

  void toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  

  @override
  Widget build(BuildContext context) {


    final header = Row(
      children : [
        Padding(padding: EdgeInsets.all(8.0) , child: _collapsed ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up) ,) ,
        Padding(padding: EdgeInsets.all(8.0) , child : widget.header ) 
      ]
    );

    final child = _collapsed ? header : Column(
      children: [
        header,
        widget.child,
      ],
    );
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: toggleCollapsed,
        child: AnimatedContainer(
          width: widget.width,
          duration: Duration(milliseconds: 700),
          decoration: widget.decoration,
          child: child,
        
        ),
      ),
    );
  }
}