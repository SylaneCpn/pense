import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/progress_bar.dart';
import 'package:provider/provider.dart';

class ProgressBarExpensesInfoWidget extends StatelessWidget {

  final RecordElement element;

  const ProgressBarExpensesInfoWidget({super.key , required this.element});

  TextStyle _textStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.slightlyBiggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratio = element.totalIncome() <= 0
        ? double.infinity
        : element.totalExpense() / element.totalIncome();
    final appState = context.watch<AppState>();
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(color: appState.lightBackgroundColor()),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
                spacing: 20.0,
                children: [
                  ProgressBar(progress: ratio, height: 30.0),
                  Text(
                    style: _textStyle(appState, context),
                    "${appState.formatWithCurrency(element.totalExpense())} / ${appState.formatWithCurrency(element.totalIncome())}",
                  ),
                  if (ratio != double.infinity)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: _textStyle(appState, context),
                            text: "Soit ",
                          ),
                          TextSpan(
                            style: _textStyle(appState, context).copyWith(
                              color: (ratio > 1.0 ? Colors.red : Colors.green).harmonizeWith(appState.backgroundColor()),
                            ),
                            text: ratio.toPercentage(2),
                          ),
                          TextSpan(
                            style: _textStyle(appState, context),
                            text: " des revenus.",
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}