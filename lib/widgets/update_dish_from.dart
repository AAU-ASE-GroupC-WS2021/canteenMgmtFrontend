import '../services/dish_service.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../models/dish.dart';
import 'package:flutter/material.dart';

class UpdateDishForm extends StatefulWidget {
  const UpdateDishForm(this.callback, {Key? key, this.dish}) : super(key: key);

  final Dish? dish;
  final Function(Dish) callback;

  @override
  State<StatefulWidget> createState() => _UpdateDishFormState();
}

class _UpdateDishFormState extends State<UpdateDishForm> {
  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  String _dishDayValue = 'NOMENUDAY';
  String _dishTypeValue = 'STARTER';
  final DishService dishService = GetIt.I<DishService>();

  final _dishTypes = [
    "STARTER",
    "MAIN",
    "DESSERT",
  ];
  final _dishDays = [
    "NOMENUDAY",
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
  ];



  @override
  Widget build(BuildContext context) {
    if (widget.dish != null) {
      controllerName.text = widget.dish!.name;
      _dishTypeValue = widget.dish!.type;
      _dishDayValue = widget.dish!.dishDay;
      controllerPrice.text = widget.dish!.price.toString();
    }
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
          TextFormField(
            controller: controllerPrice,
            decoration: const InputDecoration(
              hintText: 'Enter price of dish',
              labelText: 'price',
            ),
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: true,),
            validator: (value) => validateInputFloat(value, "dish price"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  errorStyle:
                      const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
                isEmpty: _dishTypeValue == ' ',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dishTypeValue,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        _dishTypeValue = newValue.toString();
                        state.didChange(newValue);
                      });
                    },
                    items: _dishTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: spacing),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  errorStyle:
                      const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
                isEmpty: _dishDayValue == ' ',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dishDayValue,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        _dishDayValue = newValue.toString();
                        state.didChange(newValue);
                      });
                    },
                    items: _dishDays.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
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
            child: const Text("Update Dish"),
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

  String? validateInputFloat(
    String? value,
    String label, {
    bool nonNegative = false,
  }) {
    String? notEmptyValidate = validateInputNotEmpty(value, label);
    if (notEmptyValidate == null) {
      num? result = num.tryParse(value!);
      if (result == null) {
        return '$label must be an float';
      } else if (nonNegative && result < 0) {
        return '$label must not be negative';
      }
      return null;
    }
    return notEmptyValidate;
  }

  void processInput() {
    var id = widget.dish != null ? widget.dish!.id : -1;
    Dish currentCanteenInput = Dish(
      id: id,
      name: controllerName.value.text,
      type: _dishTypeValue,
      dishDay: _dishDayValue,
      //controllerDishDay.value.text,
      price: double.parse(controllerPrice.value.text),
    );
    widget.callback(currentCanteenInput);
  }
}
