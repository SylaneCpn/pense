import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/main_page/main_page.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
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

  bool provideToNextMonth() {
    final (Month nextDateMont, int nextDateYear) = month.next(year);
    return !nextDateMont.isFuture(nextDateYear);
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        onDestinationSelected:
            (index) => setState(() {
              currentPageIndex = index;
            }),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Accueil"),
          NavigationDestination(
            icon: Icon(Icons.poll_outlined),
            label: "Données",
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: "Options"),
        ],
      ),

      body:
          [
            MainPage(
              month: month,
              year: year,
              toPrevMonth: toPrevMonth,
              toNextMonth: provideToNextMonth() ? toNextMonth : null,
            ),
            Placeholder(),
            Placeholder(),
          ][currentPageIndex],
    );
  }
}
