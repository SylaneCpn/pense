import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:pense/ui/utils/labeled_box.dart';
import 'package:pense/ui/utils/port_view.dart';

class ChipSelector extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) setSelectedIndexCallBack;
  final List<String> labels;
  const ChipSelector({
    super.key,
    required this.selectedIndex,
    required this.setSelectedIndexCallBack,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8.0,
          children: labels
              .mapIndexed(
                (index, label) => GestureDetector(
                  onTap: () => setSelectedIndexCallBack(index),
                  child: LabeledBox(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
                    label: label,
                    isSelected: index == selectedIndex,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
