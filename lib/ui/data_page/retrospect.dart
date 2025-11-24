
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class Retrospect extends StatefulWidget {
  final Month initMonth;
  final int initYear;
  const Retrospect({
    super.key,
    required this.initMonth,
    required this.initYear,
  });

  @override
  State<Retrospect> createState() => _RetrospectState();
}

class _RetrospectState extends State<Retrospect> {
  late Month beginMonth = widget.initMonth;
  late int beginYear = widget.initYear - 1;
  late Month endMonth = widget.initMonth;
  late int endYear = widget.initYear;

  void setBeginDate(Month month, int year) {
    setState(() {
      beginMonth = month;
      beginYear = year;
    });
  }

  void setEndDate(Month month, int year) {
    setState(() {
      endMonth = month;
      endYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final record = context.watch<Record>();
    const hPadding = 32.0;
    const vPadding = 12.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedContainer(
            decoration: BoxDecoration(
              color: appState.lessContrastBackgroundColor(),
            ),
            borderRadius: BorderRadius.circular(24.0),
            child: Padding(
              padding: const EdgeInsets.only(
                left: vPadding,
                right: vPadding,
                top: hPadding,
                bottom: hPadding,
              ),
              child: DateRange(
                beginMonth: beginMonth,
                beginYear: beginYear,
                endMonth: endMonth,
                endYear: endYear,
                setBeginDateCallBack: setBeginDate,
                setEndDateCallBack: setEndDate,
              ),
            ),
          ),
        ),
        ...record.elementsRange(startMonth: beginMonth, startYear: beginYear, endMonth: endMonth, endYear: endYear).map((e) => Text("${e.month.toStringFr()} ${e.year}"))

      ],
    );
  }
}

class DateRange extends StatelessWidget {
  final Month beginMonth;
  final int beginYear;
  final Month endMonth;
  final int endYear;
  final void Function(Month, int) setBeginDateCallBack;
  final void Function(Month, int) setEndDateCallBack;

  const DateRange({
    super.key,
    required this.beginMonth,
    required this.beginYear,
    required this.endMonth,
    required this.endYear,
    required this.setBeginDateCallBack,
    required this.setEndDateCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLayoutVertical = constraints.maxWidth < 450;
        final children = [
          isLayoutVertical
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: DateRangeElement(
                    alignment: Alignment.centerLeft,
                    selectedMonth: beginMonth,
                    selectedYear: beginYear,
                    setDateCallBack: setBeginDateCallBack,
                    isBegin: true,
                  ),
                )
              : DateRangeElement(
                  selectedMonth: beginMonth,
                  selectedYear: beginYear,
                  setDateCallBack: setBeginDateCallBack,
                  isBegin: true,
                ),
          isLayoutVertical
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: DateRangeElement(
                    alignment: isLayoutVertical
                        ? Alignment.centerLeft
                        : Alignment.center,
                    selectedMonth: endMonth,
                    selectedYear: endYear,
                    setDateCallBack: setEndDateCallBack,
                    isBegin: false,
                  ),
                )
              : DateRangeElement(
                  alignment: Alignment.centerLeft,
                  selectedMonth: endMonth,
                  selectedYear: endYear,
                  setDateCallBack: setEndDateCallBack,
                  isBegin: false,
                ),
        ];
        return isLayoutVertical
            ? Column(spacing: 20.0, children: children)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: children,
              );
      },
    );
  }
}

class DateRangeElement extends StatelessWidget {
  final bool isBegin;
  final Month selectedMonth;
  final int selectedYear;
  final Alignment alignment;
  final void Function(Month, int) setDateCallBack;

  const DateRangeElement({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.setDateCallBack,
    this.isBegin = true,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => DateSelector(
          setDateCallBack: setDateCallBack,
          initMonth: selectedMonth,
          initYear: selectedYear,
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: alignment,
            child: Text(
              style: TextStyle(
                color: appState.onLessContrastBackgroundColor(),
                fontSize: PortView.slightlyBiggerRegularTextSize(
                  MediaQuery.widthOf(context),
                ),
              ),
              isBegin ? "Date de début" : "Date de fin",
            ),
          ),

          Align(
            alignment: alignment,
            child: GradientTitle(
              label: "${selectedMonth.toStringFr()} $selectedYear",
            ),
          ),
        ],
      ),
    );
  }
}
