import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class RetrospectLineChart extends StatelessWidget {
  final List<RecordElement?> data;
  final DateRange dateRange;
  final CategoryType categoryType;

  const RetrospectLineChart({
    super.key,
    required this.data,
    required this.dateRange,
    required this.categoryType,
  });

  
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final title = switch(categoryType) {
      CategoryType.expense => "Dépenses",
      CategoryType.income => "Revenus"
    };
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedContainer(
        decoration: BoxDecoration(
                color: appState.lessContrastBackgroundColor(),
              ),
        borderRadius: BorderRadius.circular(8.0),
        elevation: 8.0,
        child: WithTitle(
          title: Padding(
            padding: const EdgeInsetsGeometry.only(left: 10.0, top: 20.0),
            child: GradientTitle(label: title),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  buildLineChartDate(context, appState)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text = switch (value.toInt()) {
      2 => 'MAR',
      5 => 'JUN',
      8 => 'SEP',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = switch (value.toInt()) {
      1 => '10K',
      3 => '30k',
      5 => '50k',
      _ => '',
    };

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData buildLineChartDate(BuildContext context, AppState appState) {
    final gradientMainColor = appState.primaryColor(context);
    final gradientColors=  [gradientMainColor, gradientPairColor(gradientMainColor)];
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          
        )
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: gradientMainColor ,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: gradientMainColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: gradientMainColor),
      ),
      // minX: 0,
      // maxX: 11,
      // minY: 0,
      // maxY: 6,
      lineBarsData: [
        LineChartBarData(
          // spots: const [
          //   FlSpot(0, 3),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
          spots: data.mapIndexed((index,recordElement) => FlSpot(index.toDouble(), (recordElement?.totalIncome().toDouble() ?? 0.0)/100)).toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }


}


