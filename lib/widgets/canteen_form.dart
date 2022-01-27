import 'package:flutter/services.dart';
import '../models/canteen.dart';
import 'package:flutter/material.dart';

class CanteenForm extends StatefulWidget {
  static const keyInputName = "canteenInputName";
  static const keyInputAddress = "canteenInputAddress";
  static const keyInputNumTables = "canteenInputNumTables";

  const CanteenForm(this.callback, {Key? key, this.canteen}) : super(key: key);

  final Canteen? canteen;
  final Function(Canteen) callback;

  @override
  State<StatefulWidget> createState() => _CanteenFormState();
}

class _CanteenFormState extends State<CanteenForm> {

  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();
  final controllerAddress = TextEditingController();
  final controllerNumTables = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.canteen != null) {
      controllerName.text = widget.canteen!.name;
      controllerAddress.text = widget.canteen!.address;
      controllerNumTables.text = widget.canteen!.numTables.toString();
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key(CanteenForm.keyInputName),
            controller: controllerName,
            decoration: const InputDecoration(
              hintText: 'Enter canteen name',
              labelText: 'Name',
            ),
            validator: (value) => validateInputNotEmpty(value, "canteen name"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            key: const Key(CanteenForm.keyInputAddress),
            controller: controllerAddress,
            decoration: const InputDecoration(
              hintText: 'Enter canteen address',
              labelText: 'Address',
            ),
            validator: (value) => validateInputNotEmpty(value, "canteen address"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            key: const Key(CanteenForm.keyInputNumTables),
            controller: controllerNumTables,
            decoration: const InputDecoration(
              hintText: 'Enter number of tables',
              labelText: 'Number of tables',
            ),
            keyboardType: TextInputType.number,
            validator: (value) => validateInputInteger(value, "number of tables"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.next,
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
            child: const Text('Save'),
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

  void processInput() {
    var id = widget.canteen != null ? widget.canteen!.id : -1;
    Canteen currentCanteenInput = Canteen(
      id: id,
      name: controllerName.value.text,
      address: controllerAddress.value.text,
      numTables: int.parse(controllerNumTables.value.text),);

    widget.callback(currentCanteenInput);
  }
}
