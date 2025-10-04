import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Month month = DateTime.now().month.toMonth();
  int year = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [Placeholder()]));
  }
}
