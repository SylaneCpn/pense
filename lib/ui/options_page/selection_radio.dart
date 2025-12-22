import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class SelectionRadio<T> extends StatefulWidget {
  final String label;
  final List<T> elements;
  final int selectedElementIndex;
  final bool disabled;
  final Widget Function(T element) widgetFromElement;
  final void Function(int newIndex) setIndexCallBack;

  const SelectionRadio({
    super.key,
    required this.label,
    required this.selectedElementIndex,
    required this.setIndexCallBack,
    required this.widgetFromElement,
    this.disabled = false,
    required this.elements,
  });

  @override
  State<SelectionRadio<T>> createState() => _SelectionRadioState<T>();
}

class _SelectionRadioState<T> extends State<SelectionRadio<T>> with TickerProviderStateMixin,ToggleableStateMixin  {
  TextStyle _labelStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return ElevatedContainer(
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      borderRadius: BorderRadius.circular(24.0),
      child: SizeTransition(
        sizeFactor: position,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: _labelStyle(appState, context)),
              Align(
                child: RadioGroup<int>(
                  groupValue: widget.selectedElementIndex,
                  onChanged: (value) => widget.setIndexCallBack(value!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: LayoutBuilder(
                      builder: (context ,constraints) {
                        return SizedBox(
                          width: constraints.maxWidth * 0.8,
                          child: Column(
                            spacing: 12.0,
                            children: widget.elements.indexed.map((ie) {
                              return Row(
                                children: [
                                  Expanded(child: widget.widgetFromElement(ie.$2)),
                                  Radio(value: ie.$1),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animateToValue();
  }



  @override
  void didUpdateWidget(SelectionRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.disabled != widget.disabled) {
      animateToValue();
    }
  }

 
  // Do nothing it's just visual
  @override
  ValueChanged<bool?>? get onChanged => null;
  
  @override
  bool get tristate => false;
  
  @override
  bool? get value => !widget.disabled;
}
