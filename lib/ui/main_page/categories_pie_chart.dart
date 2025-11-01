import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';

class CategoriesPieChart extends StatelessWidget {
  const CategoriesPieChart({
    super.key,
    required this.total,
    required this.categories,
  });

  final double total;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = min(600.0, constraints.maxWidth);
          return Column(
            children: [
              SizedBox(
                height: boxWidth,
                child: RawCatPieChart(
                  categories: categories,
                  boxWidth: boxWidth,
                  total: total,
                ),
              ),
              CategoriesSum(categories: categories),
            ],
          );
        },
      ),
    );
  }
}

class CategoriesSum extends StatelessWidget {
  final List<Category> _categories;
  const CategoriesSum({super.key, required List<Category> categories})
    : _categories = categories;

  @override
  Widget build(BuildContext context) {
    final List<Category> sorted = List.from(_categories)
      ..sort((a, b) => Comparable.compare(b.sourceSum(), a.sourceSum()));
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [...sorted.map((c) => CategoryChip(category: c))],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final Category category;
  static const bRadius = 20.0;
  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final style = TextStyle(
      fontSize: PortView.regularTextSize(MediaQuery.sizeOf(context).width),
      // overflow: TextOverflow.ellipsis
    );

    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(bRadius),
      child: Container(
        decoration: BoxDecoration(
          color: appState.backgroundColor(),
          borderRadius: BorderRadius.circular(bRadius),
          border: Border.all(color: appState.primaryColor(context)),
        ),
      
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(
                    right: BorderSide(color: appState.primaryColor(context)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(style: style, category.label),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                style: style,
                appState.formatWithCurrency(category.sourceSum()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RawCatPieChart extends StatelessWidget {
  const RawCatPieChart({
    super.key,
    required this.categories,
    required this.boxWidth,
    required this.total,
  });
  final double boxWidth;
  final double total;
  final List<Category> categories;

  PieChartData constructPieChartData(
    Iterable<Category> categories,
    double boxWidth,
    Color pieBaseColor,
    Color textColor
  ) => PieChartData(
    centerSpaceRadius: boxWidth / 6 ,
    sections: constructSections(categories, boxWidth, pieBaseColor,textColor),
  );

  List<PieChartSectionData> constructSections(
    Iterable<Category> categories,
    double boxWidth,
    Color pieBaseColor,
    Color textColor
  ) {
    return categories.mapIndexed((i, c) {
      final sum = c.sourceSum();
      return PieChartSectionData(
        radius: boxWidth / 2 - 20.0 - boxWidth / 6,
        color: colorShade(pieBaseColor, i, categories.length),
        title: "${c.label}\n${(sum / total).toPercentage(2)}",
        value: sum,
        titleStyle: TextStyle(color: textColor)
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          constructPieChartData(
            categories,
            boxWidth,
            appState.primaryColor(context),
            appState.backgroundColor(),
          ),
        ),
      ),
    );
  }
}
