import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/main_page/utils/accordition.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
  final String label;
  final double width;
  final CategoryType categoryType;
  final Month month;
  final int year;
  const CategoriesWidget({
    super.key,
    required this.width,
    required this.month,
    required this.year,
    required this.label,
    required this.categoryType,
  });
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final record = context.read<Record>();
    final currentElement = record.where(month,year);


    return Accordition(
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: appState.backgroundColor()),
      header: Text(style: TextStyle(color: appState.onPrimaryColor(context), fontSize: 28.0), label),
      child: Placeholder(),
    );
  }
}
