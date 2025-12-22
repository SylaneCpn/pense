import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:provider/provider.dart';

class AddSourceWidget extends StatefulWidget {
  final List<Source> sources;
  final Record record;

  const AddSourceWidget({
    super.key,
    required this.sources,
    required this.record,
  });

  @override
  State<AddSourceWidget> createState() => _AddSourceWidgetState();
}

class _AddSourceWidgetState extends State<AddSourceWidget> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static int _processAmountInput(String input) {
    final value = input.replaceAll(',', '.').replaceAll(" ", "");

    if (value.contains(".")) {
      final [whole, decimal] = value.split(".");
      return (int.tryParse(whole) ?? 0) * 100 +
          (decimal.length < 2
              ? int.tryParse("${decimal}0") ?? 0
              : int.tryParse(decimal.substring(0, 2)) ?? 0);
    }

    return (int.tryParse(value) ?? 0) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return AlertDialog(
      backgroundColor: appState.lightBackgroundColor(),
      title: const Text("Ajouter une source."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Retour"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez un titre pour cette source.";
                    }
                    return null;
                  },
                  controller: _labelController,
                  obscureText: false,
                  decoration: const InputDecoration(
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
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ajoutez une valeur à la source.";
                    }
                    try {
                      _processAmountInput(value);
                      return null;
                    } catch (e) {
                      return "La valeur n'est pas un nombre valide";
                    }
                  },
                  controller: _valueController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Montant (en ${appState.currency.symbol()})',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.sources.add(
                      Source(
                        label: _labelController.text,
                        value: _processAmountInput(_valueController.text),
                      ),
                    );
                    Navigator.pop(context);
                    widget.record.notify();
                  }
                },
                child: const Text("Ajouter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
