import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';

class SummaryBarChart extends StatelessWidget {
  final RecordElement element;
  const SummaryBarChart({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return ElevatedContainer(
      borderRadius: BorderRadius.circular(24.0),
      decoration: BoxDecoration(
        color: appState.lessContrastBackgroundColor(),
      ),
      child: WithTitle(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientTitle(label: "Comparaison"),
              Text(
                "Compairaison entre les revenus et les dépenses de ce mois-ci :",
                style: TextStyle(
                  color: appState.onLessContrastBackgroundColor(),
                  fontSize: PortView.slightlyBiggerRegularTextSize(
                    MediaQuery.widthOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context,constraints) {
            final ratio = switch (constraints.maxWidth) {
              < 600.0 => 1.7,
              < 800.0 => 2.1,
              _ => 2.9,
            };
            return RawBarChart(element: element ,aspectRatio: ratio,);
          }
        ),
      ),
    );
  }
}

class RawBarChart extends StatelessWidget {
  final RecordElement element;
  final double aspectRatio;
  const RawBarChart({super.key, required this.element, this.aspectRatio = 1.7});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final barWith = 20.0;

    BarTouchData barTouchData() => BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: barWith,
        getTooltipItem:
            (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                appState.formatWithCurrency(rod.toY.toInt()),
                TextStyle(
                  color: appState.primaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              );
            },
      ),
    );

    Widget getTitles(double value, TitleMeta meta) {
      final style = TextStyle(
        color: appState.primaryColor(context),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      String text = switch (value.toInt()) {
        0 => 'Revenus',
        1 => 'Dépenses',
        _ => '',
      };
      return SideTitleWidget(
        meta: meta,
        space: 4,
        child: Text(text, style: style),
      );
    }

    FlTitlesData titlesData() => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

    FlBorderData borderData() => FlBorderData(show: false);

    LinearGradient barsGradient() => LinearGradient(
      colors: [
        appState.primaryColor(context),
        gradientPairColor(appState.primaryColor(context)),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    List<BarChartGroupData> barGroups() => [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: element.totalIncome().toDouble(),
            gradient: barsGradient(),
            width: barWith,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: element.totalExpense().toDouble(),
            gradient: barsGradient(),
            width: barWith,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
    ];

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData(),
            titlesData: titlesData(),
            borderData: borderData(),
            barGroups: barGroups(),
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
          ),
        ),
      ),
    );
  }
}
