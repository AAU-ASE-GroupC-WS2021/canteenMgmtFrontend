import '../models/menu.dart';
import 'package:flutter/material.dart';

class DeleteMenuForm extends StatefulWidget {
  const DeleteMenuForm(this.callback, {Key? key, this.menuName = ""})
      : super(key: key);

  final String menuName;
  final Function(String) callback;

  @override
  State<StatefulWidget> createState() => _DeleteMenuFormState();
}

class _DeleteMenuFormState extends State<DeleteMenuForm> {
  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();

  List<String> menuDishNames = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controllerName,
            decoration: const InputDecoration(
              hintText: 'Enter menu name',
              labelText: 'Name',
            ),
            validator: (value) => validateInputNotEmpty(value, "menu name"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(
                40,
              ), // fromHeight use double.infinity as width and 40 is the height
            ),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                widget.callback(controllerName.value.text);
              }
            },
            child: const Text("Delete Menu"),
          ),
        ],
      ),
    );
  }

  String? validateInputNotEmpty(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
  }
}
