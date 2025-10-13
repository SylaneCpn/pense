import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/default_text.dart';
import 'package:provider/provider.dart';

import 'package:pense/logic/record.dart';

class SumBanner extends StatelessWidget {
  final Month month;
  final int year;
  final double width;
  final double height;

  const SumBanner({
    super.key,
    required this.month,
    required this.year,
    required this.width,
    required this.height,
  });

  Decoration containerDecoration(BuildContext context, AppState appState) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appState.primaryContainer(context),
          appState.backgroundColor(),
        ],
        stops: [0.0, 0.5],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final record = context.watch<Record>();
    final currentElement = record.where(month, year);

    final sum = currentElement.totalElement();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          decoration: containerDecoration(context, appState),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Epargne(sum: sum, height: height * 0.5, width: width),
                Expanded(
                  child: Row(
                    children: [
                      TopSources(
                        width: width * 0.45,
                        categoryType: CategoryType.income,
                        categories: currentElement.incomes,
                        sourceCount: 3,
                        label: "Vos sources de revenus principales :",
                      ),
                      TopSources(
                        width: width * 0.45,
                        categoryType: CategoryType.expense,
                        categories: currentElement.expenses,
                        sourceCount: 3,
                        label: "Vos dépenses principales :",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Epargne extends StatelessWidget {
  final double sum;
  final double height;
  final double width;

  Color sumColor(double sum, Color baseColor) {
    return sum > 0.0
        ? Colors.green.harmonizeWith(baseColor)
        : Colors.red.harmonizeWith(baseColor);
  }

  const Epargne({
    super.key,
    required this.sum,
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            style: TextStyle(color: appState.onPrimaryContainer(context)),
            "Epargne :",
          ),
          Text(
            style: TextStyle(
              fontSize: height / 3,
              color: sumColor(sum, appState.onPrimaryContainer(context)),
            ),
            "${sum.truncateToDecimalPlaces(2)} ${appState.currency}",
          ),
        ],
      ),
    );
  }
}

class TopSources extends StatelessWidget {
  final List<Category> categories;
  final CategoryType categoryType;
  final int sourceCount;
  final double width;
  final String label;

  const TopSources({
    super.key,
    required this.categories,
    required this.label,
    required this.sourceCount,
    required this.categoryType,
    required this.width,
  });

  TextStyle soureStyle(BuildContext context, AppState appState) {
    final color = switch (categoryType) {
      CategoryType.income => Colors.green,
      CategoryType.expense => Colors.red,
    };

    return TextStyle(
      color: color.harmonizeWith(appState.primaryColor(context)),
      fontSize: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    final sortedSources = Category.getTopSourcesInAllCategory(
      categories,
      sourceCount,
    );

    if (sortedSources.isEmpty) {
      return Expanded(
        child: DefaultText(
          missing: categoryType.toStringFr(),
          textColor: appState.onPrimaryColor(context),
        ),
      );
    }

    final sourceWidgets = sortedSources.map((s) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(s.label, style: soureStyle(context, appState)),
          Text(
            "${s.value} ${appState.currency}",
            style: soureStyle(context, appState),
          ),
        ],
      );
    });

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              style: TextStyle(
                color: appState.primaryColor(context),
                fontSize: 20,
              ),
              label,
            ),
          ),
          SizedBox(
            width: width * 0.75,
            child: Column(children: sourceWidgets.toList()),
          ),
        ],
      ),
    );
  }
}
