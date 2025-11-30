import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/chart_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/retrospect/retrospect_line_chart.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:provider/provider.dart';

class RetrospectElement extends StatelessWidget {
  final List<RecordElement?> data;
  final DateRange dateRange;
  final ChartType lineChartType;

  const RetrospectElement({
    super.key,
    required this.data,
    required this.dateRange,
    required this.lineChartType,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsetsGeometry.all(8.0),
      child: ElevatedContainer(
        decoration: BoxDecoration(
          color: appState.lessContrastBackgroundColor(),
        ),
        borderRadius: BorderRadius.circular(8.0),
        child: LayoutBuilder(
          builder: (context,constraints) {

            final ratio = switch (constraints.maxWidth) {
              < 500.0 => 1.7,
              < 800.0 => 2.1,
              _ => 2.9
            };

            return RetrospectLineChart(
              data: data,
              dateRange: dateRange,
              lineChartType: lineChartType,
              aspectRatio: ratio,
            );
          }
        ),
      ),
    );
  }
}
