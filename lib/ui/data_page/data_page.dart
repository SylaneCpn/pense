import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/data_page/retrospect.dart';
import 'package:pense/ui/utils/chip_selector.dart';

class DataPage extends StatefulWidget {
  final Month month;
  final int year;
  final void Function(Month, int)? setMonthCallBack;
  const DataPage({
    super.key,
    required this.month,
    required this.year,
    this.setMonthCallBack,
  });

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<(String, Widget)> modes = [
    ("Rétrospective", Retrospect(initMonth: widget.month, initYear: widget.year)),
  ];
  int _selectedIndex = 0;

  void _setSelectedIndex(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 20.8,
        children: [
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.only(left : 8.0),
            child: ChipSelector(
              selectedIndex: _selectedIndex,
              setSelectedIndexCallBack: _setSelectedIndex,
              labels: modes.map((m) => m.$1).toList(),
            ),
          ),

          modes[_selectedIndex].$2,
        ],
      ),
    );
  }
}
