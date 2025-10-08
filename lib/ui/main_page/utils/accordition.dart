import 'package:flutter/material.dart';

class Accordition extends StatefulWidget {
  final Widget header;
  final Widget child;
  final BoxDecoration? decoration;
  final double width;
  final Duration duration;
  final Curve curve;
  

  const Accordition({
    super.key,
    required this.header,
    required this.child,
    this.decoration,
    required this.width,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.fastLinearToSlowEaseIn
  });

  @override
  State<Accordition> createState() => _AccorditionState();
}

class _AccorditionState extends State<Accordition>
    with TickerProviderStateMixin {
  bool _collapsed = true;
  final Tween<double> tween = Tween(begin: 0.0, end: 1.0);
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
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
    final header = Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child:
              _collapsed
                  ? Icon(Icons.keyboard_arrow_down)
                  : Icon(Icons.keyboard_arrow_up),
        ),
        Padding(padding: EdgeInsets.all(8.0), child: widget.header),
      ],
    );

    final child = Column(
      children: [
        header,
        Opacity(opacity: 1.0 - _animation.value, child: SizeTransition(sizeFactor: _animation, child: widget.child)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: toggleCollapsed,
        child: Container(
          width: widget.width,
          decoration: widget.decoration,
          child: child,
        ),
      ),
    );
  }
}
