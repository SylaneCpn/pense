import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:pense/logic/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Home(),
    );
  }
}

class Home extends StatelessWidget {

  const Home({super.key});

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

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Placeholder();
  }

}