import 'package:flutter/material.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/page_switcher.dart';
import 'package:pense/ui/processing_record.dart';
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
     record?.storeRecord();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      record?.storeRecord();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final body =
        (record != null)
            ? ChangeNotifierProvider(
              create: (context) => record!,
              child: PageSwitcher(),
            )
            : ProcessingRecord();

    return SafeArea(child: Scaffold(body: body));
  }
}
