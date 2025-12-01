import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pense/logic/utils.dart';

class AppState extends ChangeNotifier {
  static final Color defaultPrimarySeedColor = Colors.greenAccent;
  static final Color defaultSecondarySeedColor = Colors.blueAccent;
  static final Color defaultTertiarySeedColor = Colors.deepPurpleAccent;
  static final avalaibleCurrencies = ['€', '£', '\$'];

  bool isDark;
  String currency = avalaibleCurrencies[0];
  bool useSystemBrightness = true;
  bool trySystemColors = true;
  bool _canUseSystemColors = false;
  late AppColors _customColors;

  bool get canUseSystemColors => _canUseSystemColors;

  AppState({this.isDark = false}) {
    _customColors = generateDefaultAppColor();
  }

  static bool isSystemDark() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  String formatWithCurrency(int amount) {
    switch (currency) {
      case '€':
        return "${amount.prettyCentsToWhole().replaceAll(".", ",")} €";
      default:
        return "$currency ${amount.prettyCentsToWhole()}";
    }
  }

  AppColors generateDefaultAppColor() {
    return AppColors(
      isDark: isDark,
      primarySeed: AppState.defaultPrimarySeedColor,
      secondarySeed: AppState.defaultSecondarySeedColor,
      tertiarySeed: AppState.defaultTertiarySeedColor,
    );
  }

  void toggleTheme() {
    isDark = !isDark;

    _customColors = AppColors(
      primarySeed: _customColors.primarySeed,
      secondarySeed: _customColors.secondarySeed,
      tertiarySeed: _customColors.tertiarySeed,
    );
    notifyListeners();
  }

  void toggleDynamicColors() {
    trySystemColors = !trySystemColors;
    notifyListeners();
  }

  void toggleUseSystemBrighness() {
    useSystemBrightness = !useSystemBrightness;
    notifyListeners();
  }

  Color primaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.primary
        : _customColors.primaryScheme.primary;
  }

  Color onPrimaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.primary
        : _customColors.primaryScheme.onPrimary;
  }

  Color secondaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.secondary
        : _customColors.secondaryScheme.primary;
  }

  Color onSecondaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onSecondary
        : _customColors.secondaryScheme.onPrimary;
  }

  Color tertiaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.tertiary
        : _customColors.tertiaryScheme.primary;
  }

  Color onTertiaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onTertiary
        : _customColors.tertiaryScheme.onPrimary;
  }

  Color onPrimaryContainer(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : _customColors.primaryScheme.onPrimaryContainer;
  }

  Color primaryContainer(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.primaryContainer
        : _customColors.primaryScheme.primaryContainer;
  }

  Color onSurface(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onSurface
        : _customColors.primaryScheme.onSurface;
  }

  Color inversePrimary(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.inversePrimary
        : _customColors.primaryScheme.inversePrimary;
  }

  Color backgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ? Colors.black : Colors.white;
    } else {
      return isDark ? Colors.black : Colors.white;
    }
  }

  Color onBackgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ? Colors.white : Colors.black;
    } else {
      return isDark ? Colors.white : Colors.black;
    }
  }

  Color lightBackgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ? Color.fromRGBO(25, 25, 25, 1.0) : Color.fromRGBO(240, 240, 240, 1.0);
    } else {
      return isDark ? Color.fromRGBO(25, 25, 25, 1.0) : Color.fromRGBO(240, 240, 240, 1.0);
    }
  }

  Color onLightBackgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ?  Colors.grey[100]! : Colors.grey[900]! ;
    } else {
      return isDark ? Colors.grey[100]! : Colors.grey[900]!;
    }
  }

  Color lessContrastBackgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ? Color.fromRGBO(15, 15, 15, 1.0) : Colors.grey[50]!;
    } else {
      return isDark ? Color.fromRGBO(15, 15, 15, 1.0) : Colors.grey[50]!;
    }
  }

  Color onLessContrastBackgroundColor() {
    if (useSystemBrightness) {
      return isSystemDark() ?  Colors.grey[50]! : Color.fromRGBO(15, 15, 15, 1.0) ;
    } else {
      return isDark ? Colors.grey[50]! : Color.fromRGBO(15, 15, 15, 1.0);
    }
  }

  

  ThemeData _theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    if (lightDynamic == null || darkDynamic == null) {
      return ThemeData(colorScheme: _customColors.primaryScheme);
    } else {
      late ColorScheme scheme;

      if (trySystemColors) {
        if (useSystemBrightness) {
          scheme = (isSystemDark()) ? darkDynamic : lightDynamic;
        } else {
          scheme = isDark ? darkDynamic : lightDynamic;
        }
      } else {
        scheme = _customColors.primaryScheme;
      }
      return ThemeData(colorScheme: scheme , fontFamily: "HankenGrotesk");
    }
  }

  ThemeData theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    _canUseSystemColors = (lightDynamic != null) && (darkDynamic != null);
    return _theme(lightDynamic, darkDynamic);
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

extension IsDark on Brightness {
  bool isDark() {
    return this == Brightness.dark;
  }
}
