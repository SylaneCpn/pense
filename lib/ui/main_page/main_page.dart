import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/main_page/categories_widget.dart';
import 'package:pense/ui/main_page/date_banner.dart';
import 'package:pense/ui/main_page/sum_banner.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.month,
    required this.year,
    this.toPrevMonth,
    this.toNextMonth,
    this.setDateCallBack,
  });

  final Month month;
  final int year;
  final void Function()? toNextMonth;
  final void Function()? toPrevMonth;
  final void Function(Month, int)? setDateCallBack;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            spacing: 10.0,
            children: [
              //Make first elements share a gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appState.inversePrimary(context),
                      appState.lightBackgroundColor(),
                    ],
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                    stops: [0.0, 0.75],
                  ),
                ),
                child: Column(
                  spacing: 10.0,

                  children: [
                    DateBanner(
                      height: 100.0,
                      month: month,
                      year: year,
                      prevMonthCallback: toPrevMonth,
                      nextMonthCallback: toNextMonth,
                      setDateCallBack: setDateCallBack,
                    ),
                    SumBanner(
                      month: month,
                      year: year,
                      width: constraints.maxWidth,
                    ),
                  ],
                ),
              ),

              // SizedBox(
              //   height: 40,
              // ),
              CategoriesWidget(
                label: "Revenus",
                categoryType: CategoryType.income,
                month: month,
                year: year,
              ),

              // SizedBox(
              //   height: 40,
              // ),
              CategoriesWidget(
                label: "Dépenses",
                categoryType: CategoryType.expense,
                month: month,
                year: year,
              ),

              // SizedBox(
              //   height: 40,
              // ),
            ],
          ),
        );
      },
    );
  }
}
