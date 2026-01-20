import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/page_switcher.dart';
import 'package:pense/ui/processing_placeholder.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with WidgetsBindingObserver {
  Record? record;

  @override
  void initState() {
    Record.getRecord().then((value) {
      setState(() {
        record = value;
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    record?.storeRecord();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await record?.storeRecord();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await record?.storeRecord();
    return super.didRequestAppExit();
  }

  @override
  Widget build(BuildContext context) {
    final body = (record != null)
        ? ChangeNotifierProvider(
            create: (context) => record!,
            child: const PageSwitcher(),
          )
        : const ProcessingPlaceholder();

    return SafeArea(child: body);
  }
}
