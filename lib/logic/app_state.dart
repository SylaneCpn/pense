import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pense/logic/currency.dart';
import 'package:pense/logic/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension ToStringFr on Color {
  String toStringFr() {
    return switch(this) {
      Colors.amber => "Ambre",
      Colors.blue => "Bleu",
      Colors.cyan => "Cyan",
      Colors.deepOrange => "Orange Foncé",
      Colors.deepPurple => "Violet Foncé",
      Colors.green => "Vert",
      Colors.lightGreen => "Vert Clair",
      Colors.indigo => "Indigo",
      Colors.lightBlue => "Bleu Clair",
      Colors.lime => "Citron",
      Colors.orange => "Orange",
      Colors.pink => "Rose",
      Colors.purple => "Violet",
      Colors.red => "Rouge",
      Colors.teal => "Turquoise",
      Colors.yellow => "Jaune",
      _ => "Inutilisé"
    };
  }
}



class AppState extends ChangeNotifier {
  static const List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.lightGreen,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lime,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  bool _isDark = false;
  bool _useSystemBrightness = true;
  bool _trySystemColors = true;
  bool _canUseSystemColors = false;
  int _colorIndex = 0;
  int _currencyIndex = 0;

  bool get isDark => _isDark;
  bool get useSystemBrightness => _useSystemBrightness;
  bool get trySystemColors => _trySystemColors;
  int get colorIndex => _colorIndex;
  int get currencyIndex => _currencyIndex;
  bool get canUseSystemColors => _canUseSystemColors;

  Brightness get brightness {
    if (_useSystemBrightness) {
      return isSystemDark() ? Brightness.dark : Brightness.light;
    }

    return _isDark ? Brightness.dark : Brightness.light;
  }

  Currency get currency => Currency.values[_currencyIndex];
  ColorScheme get _customColors => ColorScheme.fromSeed(
    seedColor: colors[_colorIndex],
    brightness: brightness,
  );

  

  AppState();

  Future<void> initFields() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    _trySystemColors = prefs.getBool('trySystemColors') ?? true;
    _currencyIndex = prefs.getInt('currencyIndex') ?? 0;
    _useSystemBrightness = prefs.getBool('useSystemBrightness') ?? true;
    _colorIndex = prefs.getInt('colorIndex') ?? 0;
    notifyListeners();
  }

  static bool isSystemDark() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  String formatWithCurrency(int amount) {
    switch (currency) {
      case Currency.euro:
        return "${amount.prettyCentsToWhole().replaceAll(".", ",")} €";
      default:
        return "${currency.symbol()} ${amount.prettyCentsToWhole()}";
    }
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = !_isDark;
    await prefs.setBool('isDark', _isDark);
    notifyListeners();
  }

  void toggleDynamicColors() async {
    final prefs = await SharedPreferences.getInstance();
    _trySystemColors = !_trySystemColors;
    await prefs.setBool('trySystemColors', _trySystemColors);
    notifyListeners();
  }

  void toggleUseSystemBrighness() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemBrightness = !_useSystemBrightness;
    await prefs.setBool('useSystemBrightness', _useSystemBrightness);
    notifyListeners();
  }

  void setCurrencyIndex(int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    _currencyIndex = newIndex;
    await prefs.setInt('currencyIndex', _currencyIndex);
    notifyListeners();
  }

  void setColorIndex(int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    _colorIndex = newIndex;
    await prefs.setInt('colorIndex', _colorIndex);
    notifyListeners();
  }

  Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  Color onPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }

  Color secondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  Color onSecondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondary;
  }

  Color tertiaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.tertiary;
  }

  Color onTertiaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.onTertiary;
  }

  Color onPrimaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimaryContainer;
  }

  Color primaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  Color onSurface(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  Color inversePrimary(BuildContext context) {
    return Theme.of(context).colorScheme.inversePrimary;
  }

  Color backgroundColor() {
    return switch (brightness) {
      Brightness.dark => Colors.black,
      Brightness.light => Colors.white,
    };
  }

  Color onBackgroundColor() {
    return switch (brightness) {
      Brightness.dark => Colors.white,
      Brightness.light => Colors.black,
    };
  }

  Color lightBackgroundColor() {
    return switch (brightness) {
      Brightness.dark => Color.fromRGBO(25, 25, 25, 1.0),
      Brightness.light => Color.fromRGBO(240, 240, 240, 1.0),
    };
  }

  Color onLightBackgroundColor() {
    return switch (brightness) {
      Brightness.dark => Colors.grey[100]!,
      Brightness.light => Colors.grey[900]!,
    };
  }

  Color lessContrastBackgroundColor() {
    return switch (brightness) {
      Brightness.dark => Color.fromRGBO(15, 15, 15, 1.0),
      Brightness.light => Colors.grey[50]!,
    };
  }

  Color onLessContrastBackgroundColor() {
    return switch (brightness) {
      Brightness.dark => Colors.grey[50]!,
      Brightness.light => Color.fromRGBO(15, 15, 15, 1.0),
    };
  }

  ThemeData _theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    if (lightDynamic == null || darkDynamic == null) {
      return ThemeData(
        colorScheme: _customColors,
        brightness: _isDark ? Brightness.dark : Brightness.light,
      );
    } else {
      late ColorScheme scheme;

      if (_trySystemColors) {
        if (_useSystemBrightness) {
          scheme = (isSystemDark()) ? darkDynamic : lightDynamic;
        } else {
          scheme = _isDark ? darkDynamic : lightDynamic;
        }
      } else {
        scheme = _customColors;
      }
      return ThemeData(colorScheme: scheme, fontFamily: "HankenGrotesk");
    }
  }

  ThemeData theme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    _canUseSystemColors = (lightDynamic != null) && (darkDynamic != null);
    return _theme(lightDynamic, darkDynamic);
  }
}
