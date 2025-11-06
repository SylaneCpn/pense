import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class LabeledBox extends StatelessWidget {
  final bool isSelected;
  final EdgeInsetsGeometry? padding;
  final bool isDesactivated;
  final String label;
  const LabeledBox({
    super.key,
    required this.label,
    this.isSelected = false,
    this.isDesactivated = false,
    this.padding
  });

  TextStyle style(BuildContext context, AppState appState, bool isSelected) {
    return TextStyle(
      color: isDesactivated
          ? Colors.grey[300]
          : isSelected
          ? appState.onPrimaryContainer(context)
          : appState.onLessContrastBackgroundColor(),
      fontSize: PortView.slightlyBiggerRegularTextSize(
        MediaQuery.widthOf(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: isDesactivated
            ? Colors.grey
            : isSelected
            ? appState.primaryContainer(context)
            : appState.lessContrastBackgroundColor(),
        border: isDesactivated
            ? null
            : Border.all(color: appState.primaryColor(context)),
      ),

      child: Center(
        child: Text(style: style(context, appState, isSelected), label),
      ),
    );
  }
}