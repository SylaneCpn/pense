import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class SelectionRadio<T> extends StatelessWidget {
  final String label;
  final List<T> elements;
  final int selectedElementIndex;
  final Widget Function(T element) widgetFromElement;
  final void Function(int newIndex) setIndexCallBack;

  const SelectionRadio({
    super.key,
    required this.label,
    required this.selectedElementIndex,
    required this.setIndexCallBack,
    required this.widgetFromElement,
    required this.elements,
  });

  TextStyle _labelStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  TextStyle _textStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.slightlyBiggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return ElevatedContainer(
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsetsGeometry.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: _labelStyle(appState, context)),
            RadioGroup<int>(
              groupValue: selectedElementIndex,
              onChanged: (value) => setIndexCallBack(value!),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  spacing: 12.0,
                  children: elements.indexed.map((ie) {
                    return LayoutBuilder(
                      builder: (context , constraints) {
                        final pad = constraints.maxWidth * (1 - 0.8) / 2;
                        return Padding(
                          padding: EdgeInsets.only(left: pad , right: pad ),
                          child: Row(
                            children: [
                              Expanded(child: widgetFromElement(ie.$2)),
                              Radio(value: ie.$1),
                            ],
                          ),
                        );
                      }
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
