import 'dart:math';

import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final Widget header;
  final Widget child;
  final Widget? tail;
  final BoxDecoration? decoration;
  final double? width;
  final Duration duration;
  final Curve curve;
  

  const Accordion({
    super.key,
    required this.header,
    this.tail,
    required this.child,
    this.decoration,
    this.width,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.fastLinearToSlowEaseIn
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion>
    with TickerProviderStateMixin {
  bool _collapsed = true;
  final Tween<double> tween = Tween(begin: 0.0, end: 1.0);
  late AnimationController _controller;
  late Animation<double> _animation;
  double _animationValue = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    
    
    _controller.addListener(() {
      setState(() {
        _animationValue = _animation.value;
      });
    });
    super.initState();
  }

  void toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });

    _collapsed ?  _controller.reverse() : _controller.forward();

    
  }

  @override
  Widget build(BuildContext context) {
    final header = GestureDetector(
      onTap: toggleCollapsed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Transform.rotate(angle: pi * _animationValue, child: Icon(Icons.keyboard_arrow_down)),
          ),
          Expanded(child: Padding(padding: EdgeInsets.all(8.0), child: widget.header)),
          if (widget.tail != null) Padding(
            padding: EdgeInsets.only(left : 10.0),
            child: widget.tail!,
          ),
        ],
      ),
    );

    final child = Column(
      children: [
        header,
        SizeTransition(sizeFactor: _animation, child: widget.child),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widget.width,
        decoration: widget.decoration,
        child: child,
      ),
    );
  }
}
