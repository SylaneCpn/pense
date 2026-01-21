import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/logic/record.dart';
import 'package:provider/provider.dart';

class RecordImporter extends StatefulWidget {
  const RecordImporter({super.key});

  @override
  State<RecordImporter> createState() => _RecordImporterState();
}

class _RecordImporterState extends State<RecordImporter> {
  PlatformFile? _file;

  static TextStyle _labelStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.biggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  static TextStyle _textStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.slightlyBiggerRegularTextSize(
        MediaQuery.widthOf(context),
      ),
    );
  }

  static ButtonStyle _buttonStyle(AppState appState, BuildContext context) {
    return TextButton.styleFrom(
      backgroundColor: appState.inversePrimary(context),
      foregroundColor: appState.onLessContrastBackgroundColor(),
    );
  }

  static SnackBar _snackBar(
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

  Future<void> _importRecord() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return;
    }

    setState(() {
      _file = result.files[0];
    });
  }

  Future<void> _useImportedRecord(
    BuildContext context,
    AppState appState,
    Record record,
  ) async {
    assert(_file != null);
    try {
      final fileData = await File(_file!.path!).readAsString();
      final json = await compute(jsonDecode, fileData);
      final newRecord = Record.fromJson(json);
      record.updateRecord(newRecord);
      record.notify();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _snackBar("Fichier importé avec succès !", appState, context),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _snackBar("Le fichier n'a pas pu être importé.", appState, context),
        );
      }
    } finally {
      setState(() {
        _file = null;
      });
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
            Text("Exporter des données", style: _labelStyle(appState, context)),
            Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: Column(
                        spacing: 24.0,
                        children: [
                          Text(
                            _file?.name ?? "Pas de fichier sélectionné.",
                            style: _textStyle(appState, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: _buttonStyle(appState, context),
                                onPressed: _importRecord,
                                child: Text("Importer un fichier"),
                              ),
                              TextButton(
                                style: _buttonStyle(appState, context),
                                onPressed: _file == null
                                    ? null
                                    : () => _useImportedRecord(context,appState, record),
                                child: Text("Utiliser le fichier importé"),
                              ),
                            ],
                          ),
                        ],
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
