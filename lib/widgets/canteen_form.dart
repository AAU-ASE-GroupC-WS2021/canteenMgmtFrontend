import 'package:flutter/services.dart';

import '../models/canteen.dart';
import 'package:flutter/material.dart';

class CanteenForm extends StatefulWidget {
  const CanteenForm({Key? key, this.canteen}) : super(key: key);

  final Canteen? canteen;

  @override
  State<StatefulWidget> createState() => _CanteenFormState();
}

class _CanteenFormState extends State<CanteenForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter canteen name',
                labelText: 'Name',
              ),
              validator: (value) => validateInputNotEmpty(value, "canteen name"),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter canteen address',
                labelText: 'Address',
              ),
              validator: (value) => validateInputNotEmpty(value, "canteen address"),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter number of tables',
                labelText: 'Number of tables',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => validateInputInteger(value, "number of tables"),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.next,
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  String? validateInputNotEmpty(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
  }

  String? validateInputInteger(String? value, String label, {bool nonNegative = false}) {
    String? notEmptyValidate = validateInputNotEmpty(value, label);
    if (notEmptyValidate == null) {
      int? result = int.tryParse(value!);
      if (result == null) {
        return '$label must be an integer';
      }
      else if (nonNegative && result < 0) {
        return '$label must not be negative';
      }
      return null;
    }
    return notEmptyValidate;
  }
}
