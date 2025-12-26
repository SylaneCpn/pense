import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/retrospect/retrospect.dart';
import 'package:pense/ui/data_page/summary/summary.dart';
import 'package:pense/ui/utils/chip_selector.dart';

class DataPage extends StatefulWidget {
  final Month month;
  final int year;
  final UnmodifiableListView<RecordElement> recordElements;
  final void Function(Month, int)? setDateCallBack;
  const DataPage({
    super.key,
    required this.month,
    required this.year,
    required this.recordElements,
    this.setDateCallBack,
  });

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _controller  = AnimationController( vsync: this , duration: Duration(milliseconds: 250));
  late final CurvedAnimation _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);


   @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void replay() {
    _controller.reset();
    _controller.forward();
  }

  void _setSelectedIndex(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
    replay();
  }

  @override
  Widget build(BuildContext context) {
    final List<(String, Widget)> modes = [
      (
        "Résumé",
        Summary(
          month: widget.month,
          year: widget.year,
          setDateCallBack: widget.setDateCallBack,
        ),
      ),
      (
        "Rétrospective",
        Retrospect(
          initMonth: widget.month,
          initYear: widget.year,
          recordElements: widget.recordElements,
        ),
      ),
    ];
    return FadeTransition(
      opacity: _animation,
      child: SingleChildScrollView(
        child: Column(
          spacing: 20.0,
          children: [
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ChipSelector(
                selectedIndex: _selectedIndex,
                setSelectedIndexCallBack: _setSelectedIndex,
                labels: modes.map((m) => m.$1).toList(),
              ),
            ),
      
            modes[_selectedIndex].$2,
          ],
        ),
      ),
    );
  }
}
