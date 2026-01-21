import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/port_view.dart';

SnackBar snackBar(
    String message,
    AppState appState,
    BuildContext context,
  ) => SnackBar(
    backgroundColor: appState.onLessContrastBackgroundColor(),
    content: Text(
      message,
      style: TextStyle(
        color: appState.lessContrastBackgroundColor(),
        fontSize: PortView.slightlyBiggerRegularTextSize(MediaQuery.widthOf(context)),
      ),
    ),
  );