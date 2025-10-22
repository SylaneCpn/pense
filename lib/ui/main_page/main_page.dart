import 'package:flutter/material.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/main_page/categories_widget.dart';
import 'package:pense/ui/main_page/date_banner.dart';
import 'package:pense/ui/main_page/sum_banner.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key , required this.month , required this.year , this.toPrevMonth , this.toNextMonth});

  final Month month;
  final int year;
  final void Function()? toNextMonth;
  final void Function()? toPrevMonth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              DateBanner(
                height: 100.0,
                month: month,
                year: year,
                prevMonthCallback: toPrevMonth,
                nextMonthCallback: toNextMonth,
              ),
              SumBanner(
                month: month,
                year: year,
                width: constraints.maxWidth,
              ),

              CategoriesWidget(
                label: "Revenus",
                categoryType: CategoryType.income,
                month: month,
                year: year,
              ),

              CategoriesWidget(
                label: "Dépenses",
                categoryType: CategoryType.expense,
                month: month,
                year: year,
              ),
            ],
          ),
        );
      },
    );
  }
}
