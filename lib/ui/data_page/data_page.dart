import 'package:flutter/material.dart';
import 'package:pense/logic/month.dart';

class DataPage extends StatelessWidget{
  final Month month;
  final int year;
  final void Function(Month , int)? setMonthCallBack;
  const DataPage({super.key , required this.month , required this.year , this.setMonthCallBack});
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

      ),
    );
  }
}