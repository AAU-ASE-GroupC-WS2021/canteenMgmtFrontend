import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/filtered_users_cubit.dart';
import '../../models/canteen.dart';
import '../../models/users/user.dart';
import '../../services/owner_user_service.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({Key? key, required this.canteens, required this.user})
      : super(key: key);

  final List<Canteen> canteens;
  final User user;

  @override
  State<StatefulWidget> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  static const spacing = 15.0;
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordRepeat = TextEditingController();

  Canteen? _selectedCanteen;
  bool _changePassword = false;

  @override
  Widget build(BuildContext context) {
    controllerUsername.text = widget.user.username;
    _selectedCanteen = findCanteenInValues(widget.user.canteenID);

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
          CheckboxListTile(
            title: const Text("Change Password"),
            value: _changePassword,
            onChanged: (newValue) {
              setState(() {
                if (newValue != null) {
                  _changePassword = newValue;
                }
              });
            },
          ),
          const SizedBox(height: spacing),
          if (_changePassword)
            TextFormField(
              controller: controllerPassword,
              decoration: const InputDecoration(
                hintText: 'Enter password',
                labelText: 'Password',
              ),
              validator: (value) => validatePassword(value),
              textInputAction: TextInputAction.next,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          if (_changePassword) const SizedBox(height: spacing),
          if (_changePassword)
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
          if (_changePassword) const SizedBox(height: spacing),
          FormBuilderDropdown(
            key: const ValueKey('dropdown'),
            initialValue: findCanteenInValues(widget.user.canteenID),
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
            onChanged: (Canteen? canteen) => _selectedCanteen = canteen,
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
                processInput();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Canteen? findCanteenInValues(int? canteenID) {
    if (canteenID == null) {
      return null;
    }
    return widget.canteens.firstWhere((element) => element.id == canteenID);
  }

  String? validateInputNotEmpty(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password field cannot be empty.';
    } else if (password.length < 9) {
      return 'Password has to be at least 9 characters long.';
    } else if (password.length > 64) {
      return 'Password cannot be longer than 64 characters.';
    }

    return null;
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
      id: widget.user.id,
      username: controllerUsername.value.text,
      password: _changePassword ? controllerPassword.value.text : null,
      canteenID: _selectedCanteen != null ? _selectedCanteen!.id : null,
      type: widget.user.type,
    );

    GetIt.I.get<OwnerUserService>().updateUser(currentUserInput).then((value) {
      Navigator.pop(context);
      GetIt.I.get<FilteredUsersCubit>().refresh();
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }
}
