import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/record.dart';
import 'package:provider/provider.dart';

class AddCategoryWidget extends StatefulWidget {
  final List<Category> categories;

  //used to to refresh the UI. For Some reason, the this provider can't be read from the context
  final Record record;

  const AddCategoryWidget({super.key, required this.categories , required this.record});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return AlertDialog(
      backgroundColor: appState.backgroundColor(),
      title: Text("Ajouter une catégorie."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Retour"),
        ),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Catégorie',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {

                widget.categories.add(Category.empty(label: _controller.text));
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
