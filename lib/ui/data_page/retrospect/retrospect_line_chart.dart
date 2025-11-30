import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/chart_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';



class RetrospectLineChart extends StatelessWidget {
  final List<RecordElement?> data;
  final DateRange dateRange;
  final ChartType lineChartType;
  final double aspectRatio;

  const RetrospectLineChart({
    super.key,
    required this.data,
    required this.dateRange,
    required this.lineChartType,
    this.aspectRatio = 1.7,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return WithTitle(
      title: Padding(
        padding: const EdgeInsetsGeometry.only(left: 10.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientTitle(label: lineChartType.title()),
            Text(
              lineChartType.subtitle(),
              style: TextStyle(
                color: appState.onLightBackgroundColor(),
                fontSize: PortView.slightlyBiggerRegularTextSize(
                  MediaQuery.widthOf(context),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(buildLineChartData(context, appState)),
          ),
        ),
      ),
    );
  }

  LineChartData buildLineChartData(BuildContext context, AppState appState) {
    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(fontWeight: FontWeight.bold);
      final numberOfMonthBegin = dateRange.beginMonth.toNumberOfMonths(
        dateRange.beginYear,
      );
      final (Month month, int year) = dateFromNumberOfMonths(
        numberOfMonthBegin + value.toInt(),
      );

      String text =
          "${month.toStringFr().substring(0, 3).toUpperCase()}\n$year";
      return SideTitleWidget(
        meta: meta,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: FittedBox(child: Text(text, style: style)),
        ),
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 7.4);

      String text = switch (value / 100) {
        < 10000.0 => (value / 100).toString(),
        _ => (value / 100).toStringAsExponential(1),
      };

      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(text, style: style, textAlign: TextAlign.left),
      );
    }

    List<LineTooltipItem?> getToolTipItems(List<LineBarSpot> spots) {
      LineTooltipItem? transform(LineBarSpot spot) {
        final textStyle = TextStyle(
          fontSize: PortView.regularTextSize(MediaQuery.widthOf(context)),
          color: appState.primaryColor(context),
        );
        final numberOfMonthBegin = dateRange.beginMonth.toNumberOfMonths(
          dateRange.beginYear,
        );
        final (Month month, int year) = dateFromNumberOfMonths(
          spot.x.toInt() + numberOfMonthBegin,
        );

        String text =
            "${month.toStringFr()}\n$year\n\n${appState.formatWithCurrency(spot.y.toInt())}";
        return LineTooltipItem(text, textStyle);
      }

      return spots.map(transform).toList();
    }

    Color getTooltipColor(LineBarSpot spot) {
      return appState.lightBackgroundColor();
    }

    //Builder
    final gradientMainColor = appState.primaryColor(context);
    final gradientColors = [
      gradientMainColor,
      gradientPairColor(gradientMainColor),
    ];
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: getTooltipColor,
          getTooltipItems: getToolTipItems,
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: gradientMainColor, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(color: gradientMainColor, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
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
          spots: data
              .mapIndexed(
                (index, recordElement) => FlSpot(
                  index.toDouble(),
                  recordElement
                          ?.totalFromChartType(lineChartType)
                          .toDouble() ??
                      0.0,
                ),
              )
              .toList(),
          isCurved: false,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
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
