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
    this.curve = Curves.fastLinearToSlowEaseIn,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> with TickerProviderStateMixin {
  bool _collapsed = true;
  late final  AnimationController _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
  late final CurvedAnimation _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  double _animationValue = 0.0;

  @override
  void initState() {
    _animation.addListener((){
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

    _collapsed ? _controller.reverse() : _controller.forward();
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
            child: Transform.rotate(
              angle: pi * _animationValue,
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(8.0), child: widget.header),
          ),
          if (widget.tail != null)
            Padding(padding: const EdgeInsets.only(left: 10.0), child: widget.tail!),
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
