import '../models/dish.dart';
import 'package:flutter/material.dart';

class DeleteDishForm extends StatefulWidget {
  const DeleteDishForm(this.callback, {Key? key, this.dishName = ""})
      : super(key: key);

  final String dishName;

  final Function(Dish) callback;

  @override
  State<StatefulWidget> createState() => _DeleteDishFormState();
}

class _DeleteDishFormState extends State<DeleteDishForm> {
  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controllerName,
            decoration: const InputDecoration(
              hintText: 'Enter dish name',
              labelText: 'Name',
            ),
            validator: (value) => validateInputNotEmpty(value, "dish name"),
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
                widget.callback(Dish(name: controllerName.value.text, price: 1.0, type: 'STARTER', dishDay: 'MONDAY', id: 1));
              }
            },
            child: const Text("Delete Dish"),
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
