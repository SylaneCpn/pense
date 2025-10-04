import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppState extends ChangeNotifier {
  late bool isDark;
  String currency = avalaibleCurrencies[0];
  late  AppColors? customColors;

  AppState() {
    isDark =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

    customColors = generateDefaultAppColor();

    
  }
  
  
  static final Color defaultPrimarySeedColor = Colors.greenAccent;
  static final Color defaultSecondarySeedColor = Colors.blueAccent;
  static final Color defaultTertiarySeedColor = Colors.deepPurpleAccent;
  AppColors generateDefaultAppColor() {
    return AppColors(
        isDark: isDark,
        primarySeed: AppState.defaultPrimarySeedColor,
        secondarySeed: AppState.defaultSecondarySeedColor,
        tertiarySeed: AppState.defaultTertiarySeedColor,
      );
  }

  static final avalaibleCurrencies = ['€', '£', '\$'];

  void toggleTheme() {
    isDark = !isDark;
    if (customColors != null) {
      customColors = AppColors(
        primarySeed: customColors!.primarySeed,
        secondarySeed: customColors!.secondarySeed,
        tertiarySeed: customColors!.tertiarySeed,
      );
    }
    notifyListeners();
  }

  Color primaryColor(BuildContext context) {
    return customColors?.primaryScheme.primary ??
        Theme.of(context).colorScheme.primary;
  }

  Color onPrimaryColor(BuildContext context) {
    return customColors?.primaryScheme.onPrimary ??
        Theme.of(context).colorScheme.primary;
  }

  Color secondaryColor(BuildContext context) {
    return customColors?.secondaryScheme.primary ??
        Theme.of(context).colorScheme.secondary;
  }

  Color onSecondaryColor(BuildContext context) {
    return customColors?.secondaryScheme.onPrimary ??
        Theme.of(context).colorScheme.onSecondary;
  }

  Color tertiaryColor(BuildContext context) {
    return customColors?.tertiaryScheme.primary ??
        Theme.of(context).colorScheme.tertiary;
  }

  Color onTertiaryColor(BuildContext context) {
    return customColors?.tertiaryScheme.onPrimary ??
        Theme.of(context).colorScheme.onTertiary;
  }

  Color onPrimaryContainer(BuildContext context) {
    return customColors?.primaryScheme.onPrimaryContainer ??  Theme.of(context).colorScheme.onPrimaryContainer;
  }

  Color primaryContainer(BuildContext context) {
    return customColors?.primaryScheme.primaryContainer ??  Theme.of(context).colorScheme.primaryContainer;
  }

  Color onSurface(BuildContext context) {
    return customColors?.primaryScheme.onSurface ?? Theme.of(context).colorScheme.onSurface;
  }

  Color inversePrimary(BuildContext context) {
    return customColors?.primaryScheme.inversePrimary ?? Theme.of(context).colorScheme.inversePrimary;
  }

  Color backgroundColor() {
    return isDark ? Colors.black : Colors.white;
  }

  Color onBackgroundColor() {
    return isDark ? Colors.white70 : Colors.black87;
  }

  ThemeData theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    if (lightDynamic == null || darkDynamic == null) {
      customColors = generateDefaultAppColor();
      return ThemeData(colorScheme: customColors!.primaryScheme);
    } else {
      final scheme =
          customColors?.primaryScheme ?? (isDark ? darkDynamic : lightDynamic);
      return ThemeData(colorScheme: scheme);
    }
  }
}

class AppColors {
  final Color primarySeed;
  final Color secondarySeed;
  final Color tertiarySeed;

  late final ColorScheme primaryScheme;
  late final ColorScheme secondaryScheme;
  late final ColorScheme tertiaryScheme;
  late final bool isDark;

  AppColors({
    required this.primarySeed,
    required this.secondarySeed,
    required this.tertiarySeed,
    bool? isDark,
  }) {
    this.isDark = isDark ?? false;
    primaryScheme = ColorScheme.fromSeed(
      brightness: this.isDark ? Brightness.dark : Brightness.light,
      seedColor: primarySeed,
    );
    secondaryScheme = ColorScheme.fromSeed(
      brightness: this.isDark ? Brightness.dark : Brightness.light,
      seedColor: secondarySeed,
    );
    tertiaryScheme = ColorScheme.fromSeed(
      brightness: this.isDark ? Brightness.dark : Brightness.light,
      seedColor: secondarySeed,
    );
  }
}
