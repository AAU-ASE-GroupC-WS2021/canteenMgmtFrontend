import '../models/user.dart';

import '../models/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateUserForm extends StatefulWidget {

  const CreateUserForm(this.callback, {Key? key, required this.canteens, this.defaultCanteen}) : super(key: key);

  final List<Canteen> canteens;
  final Function(User) callback;
  final Canteen? defaultCanteen;

  @override
  State<StatefulWidget> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {

  final _formKey = GlobalKey<FormBuilderState>();
  static const spacing = 15.0;
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordRepeat = TextEditingController();

  Canteen? _selectedCanteen;

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
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
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
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: spacing),
          FormBuilderDropdown(
            initialValue: findCanteenInValues(widget.defaultCanteen),
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
            )).toList(),
            onChanged: (Canteen? canteen) => {
              _selectedCanteen = canteen,
            },
          ),
          const SizedBox(height: spacing),
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

  Canteen? findCanteenInValues(Canteen? c) {
    if (c == null) {
      return null;
    }
    return widget.canteens.firstWhere((element) => element.id == c.id);
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
    User currentUserInput = User(
      username: controllerUsername.value.text,
      password: controllerPassword.value.text,
      canteenID: _selectedCanteen != null ? _selectedCanteen!.id : null,
      type: UserType.ADMIN,);

    widget.callback(currentUserInput);
  }
}
