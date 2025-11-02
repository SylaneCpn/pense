import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/main_page/add_source_widget.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/default_text.dart';
import 'package:pense/ui/utils/text_add_button.dart';
import 'package:provider/provider.dart';

class SourcesWidget extends StatelessWidget {
  final List<Source> sources;
  final CategoryType categoryType;
  const SourcesWidget({super.key, required this.sources , this.categoryType = CategoryType.income});

  void deleteSource(Record record, List<Source> sources, Source toRemove) {
    sources.remove(toRemove);
    record.notify();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final record = context.read<Record>();
    return Column(
      children: [
        sources.isNotEmpty
            ? Column(
              spacing: 6.0,
              children:
                  sources
                      .map(
                        (e) => Row(
                          children: [
                            Expanded(child: SourceItem(source: e , categoryType: categoryType,)),
                            IconButton(
                              onPressed: () {
                                deleteSource(record, sources, e);
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            )
            : Padding(
              padding: const EdgeInsets.only(top: 30.0,bottom: 30.0),
              child: DefaultText(
                missing: "source",
                textColor: appState.onPrimaryColor(context),
              ),
            ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: TextAddButton(
              backgroundColor: appState.primaryColor(context),
              textColor: appState.lessContrastBackgroundColor(),
              onPressed: () {
              showDialog(
                    context: context,
                    builder:
                        (context) => AddSourceWidget(
                          sources: sources,
                          record: record,
                        ),
                  );
            }, text: "Source"),
          ),
        ),
      ],
    );
  }
}

class SourceItem extends StatelessWidget {
  final Source source;
  final CategoryType categoryType;
  
  TextStyle style(BuildContext context, AppState appState) {

    final color = switch(categoryType) {
      CategoryType.income => Colors.green,
      CategoryType.expense => Colors.red
    };
    return TextStyle(color: color.harmonizeWith(appState.backgroundColor()) , fontSize: PortView.slightlyBiggerRegularTextSize(MediaQuery.sizeOf(context).width));
  }
  const SourceItem({super.key, required this.source , this.categoryType = CategoryType.income});

  @override
  Widget build(BuildContext context) {
    final appState =  context.read<AppState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(source.label, style: style(context,appState)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only( left : 14.0, right: 14.0),
          child: Text(appState.formatWithCurrency(source.value) , style: style(context,appState),),
        )
      ],
    );
  }
}
