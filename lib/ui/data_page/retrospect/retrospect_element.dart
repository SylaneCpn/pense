import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/order.dart';
import 'package:pense/logic/retrospect_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/retrospect/retrospect_line_chart.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_chip_subtitle.dart';
import 'package:pense/ui/utils/with_title.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          spacing: 20.0,
          children: [
            RetrospectAccumulated(data: data, retrospectType: retrospectType),
            RetrospectTop(data: data, retrospectType: retrospectType),
            if (retrospectType == RetrospectType.diff)
              RetrospectTop(
                data: data,
                retrospectType: retrospectType,
                order: Order.ascending,
              ),
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
            padding: EdgeInsetsGeometry.only(left: 4.0),
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

class RetrospectTop extends StatefulWidget {
  const RetrospectTop({
    super.key,
    required this.data,
    required this.retrospectType,
    this.order = Order.descending,
    this.initCount = 3,
  });
  final List<RecordElement?> data;
  final RetrospectType retrospectType;
  final int initCount;
  final Order order;

  @override
  State<RetrospectTop> createState() => _RetrospectTopState();
}

class _RetrospectTopState extends State<RetrospectTop> {
  late int count;


  @override
  void initState() {
    final elements = _generateSortedElements();
    count = widget.initCount < elements.length ? widget.initCount : elements.length;
    super.initState();
  }

  void setCount(int newCount) => setState(() => count = newCount);

  TextStyle titleStyle(BuildContext context, AppState appState) => TextStyle(
    fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    color: appState.onLightBackgroundColor(),
  );

  TextStyle elementStyle(BuildContext context, AppState appState) => TextStyle(
    fontSize: PortView.regularTextSize(MediaQuery.widthOf(context)),
    color: appState.onLightBackgroundColor(),
  );

  List<RecordElement> _generateSortedElements() => switch (widget.order) {
    Order.ascending => _generateSortedElementsAscending(),
    Order.descending => _generateSortedElementsDescending(),
  };

  List<RecordElement> _generateSortedElementsDescending() =>
      List.of(widget.data.where((e) => e != null).map((e) => e!))..sort(
        (a, b) => Comparable.compare(
          b.totalFromRetrospectType(widget.retrospectType),
          a.totalFromRetrospectType(widget.retrospectType),
        ),
      );

  List<RecordElement> _generateSortedElementsAscending() =>
      List.of(widget.data.where((e) => e != null).map((e) => e!))..sort(
        (a, b) => Comparable.compare(
          a.totalFromRetrospectType(widget.retrospectType),
          b.totalFromRetrospectType(widget.retrospectType),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final elements = _generateSortedElements();
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(color: appState.lightBackgroundColor()),
        ),
      ),
      child: WithTitle(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Top (${widget.order.toStringFr()})",
                style: titleStyle(context, appState),
              ),
            ),

            Row(
              children: [
                IconButton(onPressed:count > 1 ? () => setCount(count - 1) : null, icon: Icon(Icons.remove)),
                Text(count.toString(),style: titleStyle(context, appState),),
                IconButton(onPressed: count < elements.length ? () => setCount(count + 1) : null, icon: Icon(Icons.add))
              ],
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: elements.take(count).map((e) {
              return Row(
                children: [
                  Expanded(child: Text("${e.month.toStringFr()} ${e.year}" , style: elementStyle(context, appState),)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      appState.formatWithCurrency(
                        e.totalFromRetrospectType(widget.retrospectType),
                      ),
                      style: elementStyle(context, appState),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
