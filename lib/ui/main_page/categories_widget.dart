import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/utils/accordition.dart';
import 'package:pense/ui/utils/default_text.dart';
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

  void addCategory(Record record, List<Category> categories) {
    categories.add(Category.empty(label: "Dummy"));
    record.notify();
  }

  void deleteCategory(
    Record record,
    List<Category> categories,
    Category toRemove,
  ) {
    categories.remove(toRemove);
    record.notify();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final record = context.watch<Record>();
    final currentElement = record.where(month, year);
    final categories = switch (categoryType) {
      CategoryType.expense => currentElement.expenses,
      CategoryType.income => currentElement.incomes,
    };

    return Accordition(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: appState.backgroundColor(),
      ),
      header: Text(
        style: TextStyle(
          color: appState.onPrimaryColor(context),
          fontSize: 28.0,
        ),
        label,
      ),
      child: Column(
        children: [
          categories.isNotEmpty
              ? Column(
                children:
                    categories
                        .map(
                          (e) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CategoryWidget(
                                category: e,
                                width: width * 0.75,
                                tail: IconButton(
                                  onPressed: () {
                                    deleteCategory(record, categories, e);
                                  },
                                  icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              )
              : SizedBox(
                height: 200.0,
                child: Align(
                  alignment: Alignment.center,
                  child: DefaultText(
                    missing: "categorie",
                    textColor: appState.onPrimaryColor(context),
                  ),
                ),
              ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: IconButton(
                onPressed: () {
                  addCategory(record, categories);
                },
                icon: Icon(Icons.add, color: appState.primaryColor(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;
  final double width;
  final Widget? tail;
  const CategoryWidget({
    super.key,
    required this.category,
    required this.width,
    this.tail,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final header = Text(
      style: TextStyle(color: appState.onPrimaryColor(context), fontSize: 28.0),
      category.label,
    );

    return Accordition(
      width: width,
      header: header,
      tail: tail,
      child: Placeholder(),
    );
  }
}
