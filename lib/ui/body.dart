import 'package:flutter/material.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/main_page/main_page.dart';
import 'package:pense/ui/processing_record.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Record? record;

  @override
  void initState() {
    getRecord().then((value) {
      setState(() {
        record = value;
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    if (record != null) storeRecord(record!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final body = (record != null) ? ChangeNotifierProvider(create: (context) => record! , child: MainPage(),) : ProcessingRecord();
    
    return SafeArea(
      child: Scaffold(
        body: body,
      ),
    );
  }
}