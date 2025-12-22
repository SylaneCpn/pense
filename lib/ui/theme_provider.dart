import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/body.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends StatefulWidget  {

  const ThemeProvider({super.key});

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> with WidgetsBindingObserver {

  Brightness _brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (SchedulerBinding.instance.platformDispatcher.platformBrightness != _brightness ) {
        setState(() {
          _brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        });
      }
    }
    super.didChangeAppLifecycleState(state);
  }


  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return DynamicColorBuilder(
      builder:
          (lightDynamic, darkDynamic) => MaterialApp(
            title: 'Pense',
            theme: appState.theme(lightDynamic, darkDynamic),
            home: const Body(),
          ),
    );
  }
}