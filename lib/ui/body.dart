import 'package:flutter/material.dart';
import 'package:pense/logic/record.dart';

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

    final body = (record != null) ? Center(child : Text("Json Parsed")) : Center(child : Text("Json initialy empty"));
    
    return Scaffold(
      appBar: AppBar( backgroundColor: Theme.of(context).primaryColor,),
      body: body,
    );
  }
}