import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/snackbar.dart';
import 'package:provider/provider.dart';

class RecordExporter extends StatelessWidget {
  const RecordExporter({super.key});

  static TextStyle _labelStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  Future<void> _exportRecordMobile(
    BuildContext context,
    AppState appState,
    Record record,
  ) async {
    final recordAsJson = record.toJson();
    final recordAsString = await compute(jsonEncode, recordAsJson);
    final recordBytes = Utf8Encoder().convert(recordAsString);
    try {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: "Sauvegarder les données.",
        fileName: "record.json",
        bytes: recordBytes,
      );

      if (context.mounted && savedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar("Fichier sauvegardé avec succès.", appState, context),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar("Le fichier n'a pas pu être sauvegardé.", appState, context),
        );
      }
    }
  }

  Future<void> _exportRecord(
    BuildContext context,
    AppState appState,
    Record record,
  ) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _exportRecordMobile(context, appState, record);
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await _exportRecordDesktop(context, appState, record);
    } else {
      throw Exception("Cannot export record : Unsupported platform");
    }
  }

  Future<void> _exportRecordDesktop(
    BuildContext context,
    AppState appState,
    Record record,
  ) async {
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: "Sauvegarder les données.",
      fileName: "record.json",
    );

    if (savePath == null) return;

    try {
      final recordAsJson = record.toJson();
      final recordAsString = await compute(jsonEncode, recordAsJson);
      await File(savePath).writeAsString(recordAsString);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar("Fichier sauvegardé à \"$savePath\".", appState, context),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar("Le fichier n'a pas pu être sauvegardé.", appState, context),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final record = context.read<Record>();
    return ElevatedContainer(
      decoration: BoxDecoration(color: appState.lessContrastBackgroundColor()),
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsetsGeometry.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Exporter les données", style: _labelStyle(appState, context)),
            Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  _exportRecord(context, appState, record),
                              style: TextButton.styleFrom(
                                backgroundColor: appState.inversePrimary(
                                  context,
                                ),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: appState
                                      .onLessContrastBackgroundColor(),
                                ),
                                "Exporter",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
