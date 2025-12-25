import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/retrospect_type.dart';
import 'package:pense/ui/data_page/summary/progress_bar_expenses_info_widget.dart';
import 'package:pense/ui/data_page/summary/summary_bar_chart.dart';
import 'package:pense/ui/data_page/summary/summary_top_categories.dart';
import 'package:pense/ui/data_page/summary/summary_top_sources.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/decorated_gradient_title.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';

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
    final record = context.watch<Record>();
    final element = record.where(month, year);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        spacing: 20.0,
        children: [
          Align(
            alignment: AlignmentGeometry.centerLeft,
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

          SummaryBarChart(element: element),

          Align(
            child: SummaryInfoBox(element: element, type: RetrospectType.diff),
          ),

          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: ExpensesInfoBox(element: element),
          ),
        ],
      ),
    );
  }
}

class SummaryInfoBox extends StatelessWidget {
  final RecordElement element;
  final RetrospectType type;

  const SummaryInfoBox({super.key, required this.element, required this.type});

  Color valueColor(AppState appState, int value) {
    final color = switch (value) {
      > 0 => Colors.green,
      _ => Colors.red,
    };

    return color.harmonizeWith(appState.backgroundColor());
  }

  TextStyle _textStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.regularTextSize(MediaQuery.widthOf(context)),
    );
  }

  TextStyle _valueTextStyle(
    AppState appState,
    BuildContext context,
    int value,
  ) {
    return TextStyle(
      color: valueColor(appState, value),
      fontSize: PortView.sumBannerSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final value = element.totalFromRetrospectType(type);
    return ElevatedContainer(
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      borderRadius: BorderRadius.circular(24.0),

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: WithTitle(
          title: GradientTitle(label: type.title()),
          child: Column(
            spacing: 12.0,
            children: [
              
          
              Text("Ce mois ci : ", style: _textStyle(appState, context)),
              Text(
                style: _valueTextStyle(appState, context, value),
                appState.formatWithCurrency(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpensesInfoBox extends StatelessWidget {
  final RecordElement element;

  const ExpensesInfoBox({super.key, required this.element});

  // TextStyle _textStyle(AppState appState, BuildContext context) {
  //   return TextStyle(
  //     color: appState.onLessContrastBackgroundColor(),
  //     fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final totalIncome = element.totalIncome();
    return ElevatedContainer(
      borderRadius: BorderRadius.circular(24.0),
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: WithTitle(
          titlePadding: const EdgeInsets.only(bottom: 60.0),
          title: GradientTitle(label: "Dépenses"),
          child: Column(
            spacing: 60.0,
            children: [
              ProgressBarExpensesInfoWidget(element: element),
              SummaryTopCategories(
                categoryType: CategoryType.expense,
                element: element,
                totalIncomeRef: totalIncome,
              ),
              SummaryTopSources(
                categoryType: CategoryType.expense,
                element: element,
                totalIncomeRef: totalIncome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
