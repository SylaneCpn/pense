import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pense/logic/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const Color defaultPrimarySeedColor = Colors.greenAccent;
  static const avalaibleCurrencies = ['€', '£', '\$'];
  static const List<Color> colors = Colors.primaries;

  bool isDark = false;
  String currency = avalaibleCurrencies[0];
  bool useSystemBrightness = true;
  bool trySystemColors = true;
  bool _canUseSystemColors = false;
  ColorScheme _customColors = ColorScheme.fromSeed(seedColor: colors[0]);

  bool get canUseSystemColors => _canUseSystemColors;

  AppState();

  Future<void> initFields() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    trySystemColors = prefs.getBool('trySystemColors') ?? true;
    currency = avalaibleCurrencies[prefs.getInt("currencyIndex") ?? 0];
    useSystemBrightness = prefs.getBool('useSystemBrightness') ?? true;
    _customColors = ColorScheme.fromSeed(seedColor: colors[prefs.getInt('colorIndex') ?? 0]);
    notifyListeners();


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



  void toggleTheme() {
    isDark = !isDark;
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
        : _customColors.primary;
  }

  Color onPrimaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onPrimary
        : _customColors.onPrimary;
  }

  Color secondaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.secondary
        : _customColors.secondary;
  }

  Color onSecondaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onSecondary
        : _customColors.onSecondary;
  }

  Color tertiaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.tertiary
        : _customColors.tertiary;
  }

  Color onTertiaryColor(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onTertiary
        : _customColors.onTertiary;
  }

  Color onPrimaryContainer(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : _customColors.onPrimaryContainer;
  }

  Color primaryContainer(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.primaryContainer
        : _customColors.primaryContainer;
  }

  Color onSurface(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.onSurface
        : _customColors.onSurface;
  }

  Color inversePrimary(BuildContext context) {
    return trySystemColors && _canUseSystemColors
        ? Theme.of(context).colorScheme.inversePrimary
        : _customColors.inversePrimary;
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
      return ThemeData(colorScheme: _customColors , brightness: isDark ? Brightness.dark : Brightness.light);
    } else {
      late ColorScheme scheme;

      if (trySystemColors) {
        if (useSystemBrightness) {
          scheme = (isSystemDark()) ? darkDynamic : lightDynamic;
        } else {
          scheme = isDark ? darkDynamic : lightDynamic;
        }
      } else {
        scheme = _customColors;
      }
      return ThemeData(colorScheme: scheme , fontFamily: "HankenGrotesk");
    }
  }

  ThemeData theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    _canUseSystemColors = (lightDynamic != null) && (darkDynamic != null);
    return _theme(lightDynamic, darkDynamic);
  }
}

// class AppColors {
//   final Color seed;


//   late final ColorScheme scheme;
//   late final bool isDark;

//   AppColors({
//     required this.seed,
//     bool? isDark,
//   }) {
//     this.isDark = isDark ?? false;
//     scheme = ColorScheme.fromSeed(
//       brightness: this.isDark ? Brightness.dark : Brightness.light,
//       seedColor: seed,
//     );
//   }
// }

// extension IsDark on Brightness {
//   bool isDark() {
//     return this == Brightness.dark;
//   }
// }
