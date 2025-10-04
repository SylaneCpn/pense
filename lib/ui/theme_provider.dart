import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/body.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends StatelessWidget {

  const ThemeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return DynamicColorBuilder(
      builder:
          (lightDynamic, darkDynamic) => MaterialApp(
            title: 'Pense',
            theme: ThemeData(
              colorScheme:
                  appState.isDark
                      ? darkDynamic ??
                          ColorScheme.fromSeed(
                            brightness: Brightness.dark,
                            seedColor: AppState.defaultSeedColor,
                          )
                      : lightDynamic ??
                          ColorScheme.fromSeed(
                            seedColor: AppState.defaultSeedColor,
                          ),
            ),
            home: const Body(),
          ),
    );
  }
}