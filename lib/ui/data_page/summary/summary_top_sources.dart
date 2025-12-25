import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';

class SummaryTopSources extends StatefulWidget {
  final CategoryType categoryType;
  final RecordElement element;
  final int initCount;
  final int totalIncomeRef;

  const SummaryTopSources({
    super.key,
    required this.categoryType,
    required this.element,
    required this.totalIncomeRef,
    this.initCount = 3,
  });

  @override
  State<SummaryTopSources> createState() => _SummaryTopSourcesState();
}

class _SummaryTopSourcesState extends State<SummaryTopSources> {
  late int _count;
  late List<SourceWithCategoryRef> _sortedSources;

  String _valueWithPercentageText(
    AppState appState,
    SourceWithCategoryRef sourceWithCategoryRef,
  ) {
    final val = sourceWithCategoryRef.source.value;
    if (widget.totalIncomeRef == 0) {
      return appState.formatWithCurrency(val);
    } else {
      return "${appState.formatWithCurrency(val)} (${(val / widget.totalIncomeRef).toPercentage(2)})";
    }
  }

  TextStyle titleStyle(BuildContext context, AppState appState) => TextStyle(
    fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    color: appState.onLightBackgroundColor(),
  );

  TextStyle elementStyle(BuildContext context, AppState appState) => TextStyle(
    fontSize: PortView.regularTextSize(MediaQuery.widthOf(context)),
    color: appState.onLightBackgroundColor(),
  );

  void setCount(int newCount) => setState(() => _count = newCount);

  @override
  void initState() {
    super.initState();
    _sortedSources = widget.element.getTopSources(widget.categoryType).toList();
    _count = widget.initCount < _sortedSources.length
        ? widget.initCount
        : _sortedSources.length;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sortedSources = widget.element
        .getTopSources(widget.categoryType)
        .toList();
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
                "Top Sources (${widget.categoryType.fancyToStringFr()})",
                style: titleStyle(context, appState),
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: _count > 1 ? () => setCount(_count - 1) : null,
                  icon: Icon(Icons.remove),
                ),
                Text(_count.toString(), style: titleStyle(context, appState)),
                IconButton(
                  onPressed: _count < sortedSources.length
                      ? () => setCount(_count + 1)
                      : null,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: sortedSources.take(_count).map((e) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.source.label,
                      style: elementStyle(context, appState),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _valueWithPercentageText(appState, e),
                      style: elementStyle(context, appState),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.categoryRef.label,
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
