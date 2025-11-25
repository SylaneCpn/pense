import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/dialog_box.dart';
import 'package:pense/ui/utils/gradientify.dart';
import 'package:pense/ui/utils/labeled_box.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/actions.dart' as actions;
import 'package:provider/provider.dart';

class DateSelector extends StatefulWidget {
  final void Function(Month, int)? setDateCallBack;
  final Month initMonth;
  final int initYear;
  const DateSelector({
    super.key,
    this.setDateCallBack,
    required this.initMonth,
    required this.initYear,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late Month month = widget.initMonth;
  late int year = widget.initYear;

  bool isMonthSelected = true;

  void setIsMonthSelected(bool flag) {
    setState(() {
      isMonthSelected = flag;
    });
  }

  void setSelection(BuildContext context) {
    widget.setDateCallBack?.call(month, year);
    Navigator.pop(context);
  }

  void setMonth(Month month) {
    setState(() {
      this.month = month;
    });
  }

  void setYear(int year) {
    setState(() {
      this.year = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      child: Column(
        spacing: 16.0,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BigDate(month: month, year: year),
          DateTypeSelector(
            isMonthSelected: isMonthSelected,
            setIsMonthSelectedCallBack: setIsMonthSelected,
          ),
          Expanded(
            child: isMonthSelected
                ? MonthSelect(
                    selectedMonth: month,
                    selectedYear: year,
                    setMonthCallBack: setMonth,
                  )
                : YearSelect(selectedYear: year, selectedMonth: month, setYearCallBack: setYear),
          ),

          actions.Actions(
            actions: ["Retour", "Sélectionner"],
            actionsCallBacks: [
              () => Navigator.pop(context),
              () => setSelection(context),
            ],
          ),
        ],
      ),
    );
  }
}

class BigDate extends StatelessWidget {
  final Month month;
  final int year;

  const BigDate({super.key, required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final textStyle = TextStyle(
      fontSize: PortView.bigTextSize(MediaQuery.widthOf(context)),
      color: Colors.white,
    );
    final text = Text(style: textStyle, "${month.toStringFr()} $year");

    return Gradientify(
      gradient: LinearGradient(
        colors: [
          appState.primaryColor(context),
          gradientPairColor(appState.primaryColor(context)),
        ],
      ),
      child: text,
    );
  }
}

class DateTypeSelector extends StatelessWidget {
  final bool isMonthSelected;
  final void Function(bool) setIsMonthSelectedCallBack;
  const DateTypeSelector({
    super.key,
    required this.isMonthSelected,
    required this.setIsMonthSelectedCallBack,
  });

  TextStyle style(BuildContext context, AppState appState, bool isSelected) {
    return TextStyle(
      color: isSelected
          ? appState.onPrimaryContainer(context)
          : appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  static const padding = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setIsMonthSelectedCallBack(true),
          child: Container(
            decoration: BoxDecoration(
              color: isMonthSelected
                  ? appState.primaryContainer(context)
                  : appState.lessContrastBackgroundColor(),
              border: Border(
                top: BorderSide(color: appState.primaryColor(context)),
                left: BorderSide(color: appState.primaryColor(context)),
                bottom: BorderSide(color: appState.primaryColor(context)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                bottomLeft: Radius.circular(24.0),
              ),
            ),
            padding: padding,
            child: Text(
              style: style(context, appState, isMonthSelected),
              "Mois",
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setIsMonthSelectedCallBack(false),
          child: Container(
            decoration: BoxDecoration(
              color: !isMonthSelected
                  ? appState.primaryContainer(context)
                  : appState.lessContrastBackgroundColor(),
              border: Border.all(color: appState.primaryColor(context)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            padding: padding,
            child: Text(
              style: style(context, appState, !isMonthSelected),
              "Année",
            ),
          ),
        ),
      ],
    );
  }
}

class MonthSelect extends StatelessWidget {
  final Month selectedMonth;
  final int selectedYear;
  final void Function(Month) setMonthCallBack;
  const MonthSelect({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.setMonthCallBack,
  });

  bool isDesactivated(Month month) {
    return month.isFuture(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final count = switch (constraints.maxWidth) {
          < 150 => 1,
          < 200 => 2,
          < 400 => 3,
          < 1000 => 4,
          _ => 5,
        };
        return GridView.count(
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          crossAxisCount: count,
          children: Month.values
              .map(
                (m) => GestureDetector(
                  onTap: isDesactivated(m) ? null : () => setMonthCallBack(m),
                  child: LabeledBox(
                    label: m.toStringFr(),
                    isSelected: m == selectedMonth,
                    isDesactivated: isDesactivated(m),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class YearSelect extends StatelessWidget {
  final int selectedYear;
  final int begin;
  final Month selectedMonth;
  final void Function(int) setYearCallBack;
  const YearSelect({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.setYearCallBack,
    this.begin = 1970,
  });

  bool isDesactivated(int year) {
    return selectedMonth.isFuture(year);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final count = switch (constraints.maxWidth) {
          < 150 => 1,
          < 200 => 2,
          < 400 => 3,
          < 1000 => 4,
          _ => 5,
        };
        final currentYear = DateTime.now().year;
        return GridView.count(
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          crossAxisCount: count,
          children: List<Widget>.generate(currentYear - begin + 1, (index) {
            final year = currentYear - index;
            return GestureDetector(
              onTap: isDesactivated(year) ? null : () => setYearCallBack(year),
              child: LabeledBox(
                label: year.toString(),
                isSelected: year == selectedYear,
                isDesactivated: isDesactivated(year),
              ),
            );
          }),
        );
      },
    );
  }
}
