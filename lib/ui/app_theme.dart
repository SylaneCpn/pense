import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData theme( ColorScheme? dynamic) => ThemeData(
        colorScheme: dynamic ?? ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      );
}