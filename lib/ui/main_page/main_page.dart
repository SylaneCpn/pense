import 'package:flutter/material.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/main_page/categories_widget.dart';
import 'package:pense/ui/main_page/date_banner.dart';
import 'package:pense/ui/main_page/sum_banner.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Month month = DateTime.now().month.toMonth();
  int year = DateTime.now().year;

  void toPrevMonth() {
    setState(() {
      final (Month m, int y) = month.prev(year);
      month = m;
      year = y;
    });
  }

  void toNextMonth() {
    setState(() {
      final (Month m, int y) = month.next(year);
      month = m;
      year = y;
    });
  }

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
                height: 400.0,
                width: constraints.maxWidth,
              ),

              CategoriesWidget(
                label: "Revenus",
                width: constraints.maxWidth,
                categoryType: CategoryType.income,
                month: month,
                year: year,
              ),

              CategoriesWidget(
                label: "Dépenses",
                width: constraints.maxWidth,
                categoryType: CategoryType.income,
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
