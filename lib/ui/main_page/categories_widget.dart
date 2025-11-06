import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/main_page/add_category_widget.dart';
import 'package:pense/ui/main_page/categories_pie_chart.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/main_page/sources_widget.dart';
import 'package:pense/ui/utils/accordion.dart';
import 'package:pense/ui/utils/default_text.dart';
import 'package:pense/ui/utils/text_add_button.dart';
import 'package:pense/ui/utils/gradient_chip.dart';
import 'package:pense/ui/utils/with_title.dart';
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

    final total = categories.fold(0, (acc, c) => acc + c.sourceSum());
    final labelColor = appState.primaryColor(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedContainer(
        borderRadius: BorderRadius.circular(8.0),
        elevation: 8.0,
        decoration: BoxDecoration(
          color: appState.lightBackgroundColor(),
          gradient: LinearGradient(
            begin: AlignmentGeometry.topRight,
            end: AlignmentGeometry.bottomLeft,
            colors: [
              appState.primaryContainer(context),
              appState.lightBackgroundColor(),
              appState.lightBackgroundColor(),
              appState.primaryContainer(context),
            ],
            stops: [0, 0.2, 0.8, 1],
            transform: GradientRotation(12.0),
          ),
        ),
        child: WithTitle(
          title: Padding(
            padding: const EdgeInsetsGeometry.only(left: 10.0, top: 20.0),
            child: GradientTitle(label: label),
          ),

          child: Column(
            children: [
              categories.isNotEmpty
                  ? Column(
                      children: [
                        if (total > 0.0)
                          WithTitle(
                            leading: GradientChip(
                              start: labelColor,
                              end: gradientPairColor(labelColor),
                              width: 4.0,
                              height: PortView.bigTextSize(
                                MediaQuery.widthOf(context),
                              ),
                              borderRadius: 4.0,
                            ),
                            titlePadding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                              bottom: 10.0,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                style: TextStyle(
                                  color: appState.onLightBackgroundColor(),
                                  fontSize: PortView.mediumTextSize(
                                    MediaQuery.sizeOf(context).width,
                                  ),
                                ),
                                "Vue d'ensemble",
                              ),
                            ),
                            child: CategoriesPieChart(
                              total: total,
                              categories: categories,
                            ),
                          ),
                        WithTitle(
                          leading: GradientChip(
                            start: labelColor,
                            end: gradientPairColor(labelColor),
                            width: 4.0,
                            height: PortView.bigTextSize(
                              MediaQuery.widthOf(context),
                            ),
                            borderRadius: 4.0,
                          ),
                          titlePadding: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            bottom: 10.0,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              style: TextStyle(
                                color: appState.onLightBackgroundColor(),
                                fontSize: PortView.mediumTextSize(
                                  MediaQuery.sizeOf(context).width,
                                ),
                              ),
                              "Catégories",
                            ),
                          ),
                          child: Column(
                            children: [
                              ...categories.map(
                                (c) => CategoryWidget(
                                  category: c,
                                  onDeleteCallBack: () {
                                    deleteCategory(record, categories, c);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: DefaultText(
                        missing: "catégorie",
                        textColor: appState.onLessContrastBackgroundColor(),
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: TextAddButton(
                    textColor: appState.onBackgroundColor(),
                    backgroundColor: appState.inversePrimary(context),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddCategoryWidget(
                          categories: categories,
                          record: record,
                        ),
                      );
                    },
                    text: "Catégorie",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Accordion(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8.0),
    //     color: appState.backgroundColor(),
    //   ),
    //   header: Text(
    //     style: TextStyle(
    //       color: appState.onPrimaryColor(context),
    //       fontSize: PortView.doubleRegularTextSize(
    //         MediaQuery.sizeOf(context).width,
    //       ),
    //     ),
    //     label,
    //   ),
    //   child: Column(
    //     children: [
    //       categories.isNotEmpty
    //           ? Column(
    //             children: [
    //               if (total > 0.0)
    //                 WithTitle(
    //                   style: TextStyle(color: appState.primaryColor(context) , fontSize: PortView.bigTextSize(MediaQuery.sizeOf(context).width)),
    //                   title: "Vue d'ensemble",
    //                   padding: const EdgeInsets.all(10.0),
    //                   child: CategoriesPieChart(
    //                     total: total,
    //                     categories: categories,
    //                   ),
    //                 ),
    //               WithTitle(
    //                 style: TextStyle(
    //                   color: appState.primaryColor(context),
    //                   fontSize: PortView.bigTextSize(
    //                     MediaQuery.sizeOf(context).width,
    //                   ),
    //                 ),
    //                 padding: const EdgeInsets.all(10.0),
    //                 title: "Détails",
    //                 child: Column(
    //                   children: [
    //                     ...categories.map(
    //                       (e) => Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Expanded(
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: CategoryWidget(
    //                                 category: e,
    //                                 categoryType: categoryType,
    //                                 tail: IconButton(
    //                                   onPressed: () {
    //                                     deleteCategory(record, categories, e);
    //                                   },
    //                                   icon: Icon(
    //                                     Icons.delete_forever_rounded,
    //                                     color: Colors.red,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           )
    //           : Padding(
    //             padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
    //             child: DefaultText(
    //               missing: "catégorie",
    //               textColor: appState.onPrimaryColor(context),
    //             ),
    //           ),

    //       Padding(
    //         padding: const EdgeInsets.all(18.0),
    //         child: Center(
    //           child: TextAddButton(
    //             onPressed: () {
    //               showDialog(
    //                 context: context,
    //                 builder:
    //                     (context) => AddCategoryWidget(
    //                       categories: categories,
    //                       record: record,
    //                     ),
    //               );
    //             },
    //             text: "Catégorie",
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;
  final Widget? tail;
  final CategoryType categoryType;
  final void Function() onDeleteCallBack;
  const CategoryWidget({
    super.key,
    required this.category,
    required this.onDeleteCallBack,
    this.tail,
    this.categoryType = CategoryType.income,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final header = Text(
      style: TextStyle(
        color: appState.onLightBackgroundColor(),
        fontSize: PortView.mediumTextSize(MediaQuery.sizeOf(context).width),
      ),
      category.label,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: appState.lessContrastBackgroundColor(),
              elevation: 8.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Accordion(
                header: header,
                tail: IconButton(
                  onPressed: onDeleteCallBack,
                  icon: Transform.rotate(
                    angle: pi / 4,
                    child: Icon(Icons.add, color: Colors.red),
                  ),
                ),
                child: SourcesWidget(
                  sources: category.sources,
                  categoryType: categoryType,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
