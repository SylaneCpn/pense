import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/dialog_box.dart';
import 'package:pense/ui/utils/gradientify.dart';
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
                  ? MonthSelect(month: month, setMonthCallBack: setMonth)
                  : YearSelect(year: year),
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
  final Month month;
  final void Function(Month) setMonthCallBack;
  const MonthSelect({
    super.key,
    required this.month,
    required this.setMonthCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      crossAxisCount: 3,
      children: List.generate(
        12,
        (index) => GestureDetector(
          onTap: () => setMonthCallBack(Month.values[index]),
          child: MonthBox(
            month: Month.values[index],
            isSelected: Month.values[index] == month,
          ),
        ),
      ),
    );
  }
}

class MonthBox extends StatelessWidget {
  final bool isSelected;
  final Month month;
  const MonthBox({super.key, required this.month, this.isSelected = false});

  TextStyle style(BuildContext context, AppState appState, bool isSelected) {
    return TextStyle(
      color: isSelected
          ? appState.onPrimaryContainer(context)
          : appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected
            ? appState.primaryContainer(context)
            : appState.lessContrastBackgroundColor(),
        border: Border.all(color: appState.primaryColor(context)),
        borderRadius: BorderRadius.circular(24.0),
      ),

      child: Center(
        child: Text(
          style: style(context, appState, isSelected),
          month.toStringFr(),
        ),
      ),
    );
  }
}

class YearSelect extends StatelessWidget {
  final int year;
  const YearSelect({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Placeholder();
  }
}


