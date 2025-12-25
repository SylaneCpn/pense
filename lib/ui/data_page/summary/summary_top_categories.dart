import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';

class SummaryTopCategories  extends StatefulWidget{

  final CategoryType categoryType;
  final RecordElement element;
  final int totalIncomeRef;
  final int initCount;

  const SummaryTopCategories({super.key , required this.categoryType , required this.element ,required this.totalIncomeRef, this.initCount = 3});

  @override
  State<SummaryTopCategories> createState() => _SummaryTopCategoriesState();
}

class _SummaryTopCategoriesState extends State<SummaryTopCategories> {

  late int _count;
  late List<Category> _sortedCategorires;

  String _valueWithPercentageText(
    AppState appState,
    Category category,
  ) {
    final sum = category.sourceSum();
    if (widget.totalIncomeRef == 0) {
      return appState.formatWithCurrency(sum);
    } else {
      return "${appState.formatWithCurrency(sum)} (${(sum / widget.totalIncomeRef).toPercentage(2)})";
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
    _sortedCategorires = widget.element.getTopCategories(widget.categoryType).toList();
    _count = widget.initCount < _sortedCategorires.length ? widget.initCount : _sortedCategorires.length;
  
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sortedCategorires = widget.element.getTopCategories(widget.categoryType).toList();
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
                "Top Catégories (${widget.categoryType.fancyToStringFr()})",
                style: titleStyle(context, appState),
              ),
            ),

            Row(
              children: [
                IconButton(onPressed:_count > 1 ? () => setCount(_count - 1) : null, icon: Icon(Icons.remove)),
                Text(_count.toString(),style: titleStyle(context, appState),),
                IconButton(onPressed: _count < sortedCategorires.length ? () => setCount(_count + 1) : null, icon: Icon(Icons.add))
              ],
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: sortedCategorires.take(_count).map((e) {
              return Row(
                children: [
                  Expanded(child: Text(e.label , style: elementStyle(context, appState),)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _valueWithPercentageText(appState, e),
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