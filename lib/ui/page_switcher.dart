import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/data_page/data_page.dart';
import 'package:pense/ui/main_page/main_page.dart';
import 'package:pense/ui/options_page/options_page.dart';
import 'package:provider/provider.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> with TickerProviderStateMixin {

  late final AnimationController _controller  = AnimationController( vsync: this , duration: Duration(milliseconds: 250));
  late final CurvedAnimation _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void replay() {
    _controller.reset();
    _controller.forward();
  }

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
          replay();
        }),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: "Accueil"),
          const NavigationDestination(
            icon: Icon(Icons.poll_outlined),
            label: "Données",
          ),
          const NavigationDestination(icon: Icon(Icons.settings), label: "Options"),
        ],
      ),

      body: FadeTransition(opacity: _animation , child :[
        MainPage(
          month: month,
          year: year,
          toPrevMonth: toPrevMonth,
          toNextMonth: provideToNextMonth() ? toNextMonth : null,
          setDateCallBack: setDate,
        ),
        DataPage(
          month: month,
          year: year,
          setMonthCallBack: setDate,
          recordElements: record.elements,
        ),
        const OptionsPage(),
      ][currentPageIndex]) ,
    );
  }
}
