import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/decorated_gradient_title.dart';

class Summary extends StatelessWidget {
  final Month month;
  final int year;
  final void Function(Month, int)? setDateCallBack;

  const Summary({
    super.key,
    required this.month,
    required this.year,
    required this.setDateCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left : 20.0),
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => DateSelector(
                  initMonth: month,
                  initYear: year,
                  setDateCallBack: setDateCallBack,
                ),
              ),
              child: DecoratedGradientTitle(
                innerPadding: EdgeInsets.all(20.0),
                label: "${month.toStringFr()} $year",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
