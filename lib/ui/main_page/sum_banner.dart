import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/default_text.dart';
import 'package:provider/provider.dart';

import 'package:pense/logic/record.dart';

class SumBanner extends StatelessWidget {
  final Month month;
  final int year;
  final double width;

  static const bRadius = 8.0;

  const SumBanner({
    super.key,
    required this.month,
    required this.year,
    required this.width,
  });

  BoxDecoration containerDecoration(BuildContext context, AppState appState) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(bRadius),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appState.inversePrimary(context),
          appState.lessContrastBackgroundColor(),
        ],
        stops: [0.0, 0.66],
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
      child: ElevatedContainer(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(bRadius),
          decoration: containerDecoration(context, appState),
          child: Column(
            children: [
              Epargne(sum: sum, height: 120),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width / 20,
                        right: width / 20,
                        bottom: 40.0,
                      ),
                      child: TopSources(
                        categoryType: CategoryType.income,
                        categories: currentElement.incomes,
                        sourceCount: 3,
                        label: "Revenus principaux :",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width / 20,
                        right: width / 20,
                        bottom: 40.0,
                      ),
                      child: TopSources(
                        categoryType: CategoryType.expense,
                        categories: currentElement.expenses,
                        sourceCount: 3,
                        label: "Dépenses principales :",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

class Epargne extends StatelessWidget {
  final int sum;
  final double height;

  Color sumColor(int sum, Color baseColor) {
    return sum > 0
        ? Colors.green.harmonizeWith(baseColor)
        : Colors.red.harmonizeWith(baseColor);
  }

  const Epargne({super.key, required this.sum, required this.height});
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Padding(
      padding: EdgeInsets.only(top: height / 2, bottom: height / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            style: TextStyle(
              color: appState.onLightBackgroundColor(),
              fontSize: PortView.regularTextSize(
                MediaQuery.sizeOf(context).width,
              ),
            ),
            "Epargne :",
          ),
          Text(
            textAlign:  TextAlign.center,
            style: TextStyle(
              fontSize: PortView.sumBannerSize(
                MediaQuery.sizeOf(context).width,
              ),
              color: sumColor(sum, appState.lessContrastBackgroundColor()),
            ),
            appState.formatWithCurrency(sum),
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
  final String label;

  const TopSources({
    super.key,
    required this.categories,
    required this.label,
    required this.sourceCount,
    required this.categoryType,
  });

  TextStyle soureStyle(BuildContext context, AppState appState) {
    final color = switch (categoryType) {
      CategoryType.income => Colors.green,
      CategoryType.expense => Colors.red,
    };

    return TextStyle(
      color: color.harmonizeWith(appState.backgroundColor()),
      fontSize: PortView.regularTextSize(
        MediaQuery.sizeOf(context).width,
      ),
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
      return DefaultText(
        missing: categoryType.toStringFr(),
        textColor: appState.onLightBackgroundColor(),
      );
    }

    final sourceWidgets = sortedSources.map((s) {
      return Row(
        children: [
          Expanded(
            child: Text(
              overflow: TextOverflow.clip,
              s.label,
              style: soureStyle(context, appState),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              appState.formatWithCurrency(s.value),
              style: soureStyle(context, appState),
            ),
          ),
        ],
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.0,
      children: [
        Text(
          style: TextStyle(
            color: appState.onLightBackgroundColor(),
            fontSize: PortView.mediumTextSize(
              MediaQuery.sizeOf(context).width,
            ),
          ),
          label,
        ),
        Column(spacing: 18.0, children: sourceWidgets.toList()),
      ],
    );
  }
}
