import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:provider/provider.dart';

class AddSourceWidget extends StatefulWidget {
  final List<Source> sources;
  final Record record;

  const AddSourceWidget({super.key, required this.sources, required this.record});

  @override
  State<AddSourceWidget> createState() => _AddSourceWidgetState();
}

class _AddSourceWidgetState extends State<AddSourceWidget> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();


  double processAmountInput() {
    final value = _valueController.text.replaceAll(',', '.').replaceAll(" ", "");
    return double.tryParse(value) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return AlertDialog(
      backgroundColor: appState.backgroundColor(),
      title: Text("Ajouter une source."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Retour"),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _labelController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Source',
                ),
              ),
            ),
          ),

          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _valueController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Montant (en ${appState.currency})',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                widget.sources.add(
                  Source(
                    label: _labelController.text,
                    value: processAmountInput(),
                  ),
                );
                Navigator.pop(context);
                widget.record.notify();
              },
              child: Text("Ajouter"),
            ),
          ),
        ],
      ),
    );
  }
}
