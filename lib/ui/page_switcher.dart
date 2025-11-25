import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/data_page.dart';
import 'package:pense/ui/main_page/main_page.dart';
import 'package:provider/provider.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  Month month = DateTime.now().month.toMonth();
  int year = DateTime.now().year;

  void setDate(Month month, int year) {
    setState(() {
      this.month = month;
      this.year = year;
    });
  }

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
    final appState = context.watch<AppState>();
    final record = context.watch<Record>();
    return Scaffold(
      backgroundColor: appState.lightBackgroundColor(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: appState.lightBackgroundColor(),
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) => setState(() {
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

      body: [
        MainPage(
          month: month,
          year: year,
          toPrevMonth: toPrevMonth,
          toNextMonth: provideToNextMonth() ? toNextMonth : null,
          setDateCallBack: setDate,
        ),
        DataPage(month: month, year: year, setMonthCallBack: setDate , record: record,),
        Placeholder(),
      ][currentPageIndex],
    );
  }
}
