import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppState extends ChangeNotifier {

  bool isDark = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  String currency = avalaibleCurrencies[0];



  static final Color defaultSeedColor = Colors.greenAccent;
  static final avalaibleCurrencies = ['€' , '£' , '\$'];


  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }


  
}