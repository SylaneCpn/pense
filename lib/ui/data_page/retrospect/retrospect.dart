import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/retrospect_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/retrospect/invalid_range.dart';
import 'package:pense/ui/data_page/retrospect/retrospect_element.dart';
import 'package:pense/ui/processing_placeholder.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

// Sorting the List may be a long computation depending on
// the lenght of the list.
// The computation is moved to an isolate to prevent the ui to freeze.
class Retrospect extends StatefulWidget {
  final Month initMonth;
  final int initYear;
  final UnmodifiableListView<RecordElement> recordElements;

  const Retrospect({
    super.key,
    required this.initMonth,
    required this.initYear,
    required this.recordElements,
  });

  @override
  State<Retrospect> createState() => _RetrospectState();
}

class _RetrospectState extends State<Retrospect> {
  late DateRange dateRange = DateRange(
    beginMonth: widget.initMonth,
    beginYear: widget.initYear - 1,
    endMonth: widget.initMonth,
    endYear: widget.initYear,
  );

  List<RecordElement?>? data;

  void setBeginDate(Month month, int year) {
    dateRange.beginMonth = month;
    dateRange.beginYear = year;
    reloadData();
  }

  void setEndDate(Month month, int year) {
    dateRange.endMonth = month;
    dateRange.endYear = year;
    reloadData();
  }

  void getData() {
    computeMaybeRecordElementsRange(widget.recordElements, dateRange).then((
      value,
    ) {
      setState(() {
        data = value;
      });
    });
  }

  void reloadData() {
    setState(() {
      data = null;
    });

    getData();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const ProcessingPlaceholder(viewPortHeighRatio: 0.66);
    } else {
      return RetrospectLoaded(
        dateRange: dateRange,
        setBeginDate: setBeginDate,
        setEndDate: setEndDate,
        data: data!,
      );
    }
  }
}

class RetrospectLoaded extends StatelessWidget {
  final DateRange dateRange;
  final void Function(Month, int) setBeginDate;
  final void Function(Month, int) setEndDate;
  final List<RecordElement?> data;

  const RetrospectLoaded({
    super.key,
    required this.dateRange,
    required this.setBeginDate,
    required this.setEndDate,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    const hPadding = 32.0;
    const vPadding = 12.0;
    return Column(
      spacing: 10.0,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedContainer(
            decoration: BoxDecoration(
              color: appState.lessContrastBackgroundColor(),
            ),
            borderRadius: BorderRadius.circular(24.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: vPadding,
                horizontal: hPadding,
              ),
              child: DateRangeSelector(
                dateRange: dateRange,
                setBeginDateCallBack: setBeginDate,
                setEndDateCallBack: setEndDate,
              ),
            ),
          ),
        ),
        if (data.isNotEmpty) ...[
          RetrospectElement(
            data: data,
            dateRange: dateRange,
            retrospectType: RetrospectType.diff,
          ),

          RetrospectElement(
            data: data,
            dateRange: dateRange,
            retrospectType: RetrospectType.income,
          ),

          RetrospectElement(
            data: data,
            dateRange: dateRange,
            retrospectType: RetrospectType.expense,
          ),
        ],

        if (data.isEmpty) InvalidRange(),
      ],
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

class DateRangeSelector extends StatelessWidget {
  final DateRange dateRange;
  final void Function(Month, int) setBeginDateCallBack;
  final void Function(Month, int) setEndDateCallBack;

  const DateRangeSelector({
    super.key,
    required this.dateRange,
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
                    selectedMonth: dateRange.beginMonth,
                    selectedYear: dateRange.beginYear,
                    setDateCallBack: setBeginDateCallBack,
                    isBegin: true,
                  ),
                )
              : DateRangeElement(
                  selectedMonth: dateRange.beginMonth,
                  selectedYear: dateRange.beginYear,
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
                    selectedMonth: dateRange.endMonth,
                    selectedYear: dateRange.endYear,
                    setDateCallBack: setEndDateCallBack,
                    isBegin: false,
                  ),
                )
              : DateRangeElement(
                  alignment: Alignment.centerLeft,
                  selectedMonth: dateRange.endMonth,
                  selectedYear: dateRange.endYear,
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
