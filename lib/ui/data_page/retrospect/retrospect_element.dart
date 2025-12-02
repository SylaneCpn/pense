import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/retrospect_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/retrospect/retrospect_line_chart.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_chip_subtitle.dart';
import 'package:provider/provider.dart';

class RetrospectElement extends StatelessWidget {
  final List<RecordElement?> data;
  final DateRange dateRange;
  final RetrospectType retrospectType;

  const RetrospectElement({
    super.key,
    required this.data,
    required this.dateRange,
    required this.retrospectType,
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
          builder: (context, constraints) {
            final ratio = switch (constraints.maxWidth) {
              < 600.0 => 1.7,
              < 800.0 => 2.1,
              _ => 2.9,
            };

            return Column(
              children: [
                RetrospectLineChart(
                  data: data,
                  dateRange: dateRange,
                  lineChartType: retrospectType,
                  aspectRatio: ratio,
                ),

                RetrospectInfos(
                  data: data,
                  dateRange: dateRange,
                  retrospectType: retrospectType,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RetrospectInfos extends StatelessWidget {
  final List<RecordElement?> data;
  final DateRange dateRange;
  final RetrospectType retrospectType;

  const RetrospectInfos({
    super.key,
    required this.data,
    required this.dateRange,
    required this.retrospectType,
  });

  @override
  Widget build(BuildContext context) {
    return WithChipSubtitle(
      subtitle: "Informations",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        child: Column(
          children: [
            RetrospectAccumulated(data: data, retrospectType: retrospectType),
          ],
        ),
      ),
    );
  }
}

class RetrospectAccumulated extends StatelessWidget {
  final List<RecordElement?> data;
  final RetrospectType retrospectType;

  const RetrospectAccumulated({
    super.key,
    required this.data,
    required this.retrospectType,
  });

  int cumulated() => data
      .map((e) => e?.totalFromRetrospectType(retrospectType) ?? 0)
      .fold(0, (acc, elem) => acc + elem);

  TextStyle style(BuildContext context, AppState appState) => TextStyle(
    fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    color: appState.onLightBackgroundColor(),
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(color: appState.lightBackgroundColor()),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text("Cumulé ", style: style(context, appState))),
    
          Padding(
            padding: EdgeInsetsGeometry.only(left : 4.0),
            child: Text(
              appState.formatWithCurrency(cumulated()),
              style: style(context, appState),
            ),
          ),
        ],
      ),
    );
  }
}
