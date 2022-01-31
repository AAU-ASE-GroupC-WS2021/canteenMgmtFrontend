import '../models/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateUserForm extends StatefulWidget {

  const CreateUserForm(this.callback, {Key? key, required this.canteens}) : super(key: key);

  final List<Canteen> canteens;
  // TODO: Add user argument
  final Function() callback;

  @override
  State<StatefulWidget> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {

  final _formKey = GlobalKey<FormBuilderState>();
  static const spacing = 15.0;
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordRepeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: controllerUsername,
            decoration: const InputDecoration(
              hintText: 'Enter username',
              labelText: 'Username',
            ),
            validator: (value) => validateInputNotEmpty(value, "username"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            controller: controllerPassword,
            decoration: const InputDecoration(
              hintText: 'Enter password',
              labelText: 'Password',
            ),
            validator: (value) => validatePassword(value, "password"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            controller: controllerPasswordRepeat,
            decoration: const InputDecoration(
              hintText: 'Repeat password',
              labelText: 'Repeat Password',
            ),
            validator: (value) => validatePasswordRepeat(value, "password"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          FormBuilderDropdown(
            name: 'canteen',
            decoration: const InputDecoration(
              labelText: 'Canteen',
            ),
            allowClear: true,
            hint: const Text('Select Home Canteen'),
            items: widget.canteens
                .map((canteen) => DropdownMenuItem(
              value: canteen,
              child: Text('$canteen'),
            ))
                .toList(),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
            ),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                processInput();
              }
            },
            child: const Text('Create User'),
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

  String? validatePassword(String? value, String label) {
    String? notEmptyValidate = validateInputNotEmpty(value, label);
    // TODO: add validation
    return notEmptyValidate;
  }

  String? validatePasswordRepeat(String? value, String label) {
    String? notEmptyValidate = validateInputNotEmpty(value, label);
    if (notEmptyValidate == null) {
      if (value != controllerPassword.value.text) {
        return "Passwords do not match";
      }
    }
    return notEmptyValidate;
  }

  void processInput() {
    // TODO: add user
  }
}
