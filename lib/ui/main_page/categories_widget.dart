import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/main_page/add_category_widget.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/main_page/sources_widget.dart';
import 'package:pense/ui/utils/accordion.dart';
import 'package:pense/ui/utils/default_text.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
  final String label;
  final CategoryType categoryType;
  final Month month;
  final int year;
  const CategoriesWidget({
    super.key,
    required this.month,
    required this.year,
    required this.label,
    required this.categoryType,
  });

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

    return Accordion(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: appState.backgroundColor(),
      ),
      header: Text(
        style: TextStyle(
          color: appState.onPrimaryColor(context),
          fontSize: PortView.doubleRegularTextSize(MediaQuery.sizeOf(context).width),
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CategoryWidget(
                                    category: e,
                                    categoryType: categoryType,
                                    tail: IconButton(
                                      onPressed: () {
                                        deleteCategory(record, categories, e);
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
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
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AddCategoryWidget(
                          categories: categories,
                          record: record,
                        ),
                  );
                },
                child: Text(" + Catégorie"),
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
  final Widget? tail;
  final CategoryType categoryType;
  const CategoryWidget({
    super.key,
    required this.category,
    this.tail,
    this.categoryType = CategoryType.income
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final header = Text(
      style: TextStyle(color: appState.onPrimaryColor(context), fontSize: PortView.doubleRegularTextSize(MediaQuery.sizeOf(context).width)),
      category.label,
    );

    return Accordion(
      header: header,
      tail: tail,
      decoration: BoxDecoration(
        border: Border.all(color: appState.primaryColor(context)),
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: SourcesWidget(sources: category.sources, categoryType: categoryType,),
    );
  }
}
