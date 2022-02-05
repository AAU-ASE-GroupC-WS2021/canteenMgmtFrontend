import 'package:canteen_mgmt_frontend/services/dish_service.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../models/dish.dart';
import 'package:flutter/material.dart';


class CreateDishForm extends StatefulWidget {

  const CreateDishForm(this.callback, {Key? key, this.dish}) : super(key: key);

  final Dish? dish;
  final Function(Dish) callback;

  @override
  State<StatefulWidget> createState() => _CreateDishFormState();
}

class _CreateDishFormState extends State<CreateDishForm> {

  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();
  final controllerType = TextEditingController();
  final controllerDishDay = TextEditingController();
  final controllerPrice = TextEditingController();
  final DishService dishService = GetIt.I<DishService>();

  @override
  Widget build(BuildContext context) {
    if (widget.dish != null) {
      controllerName.text = widget.dish!.name;
      controllerType.text = widget.dish!.type;
      controllerDishDay.text = widget.dish!.dishDay;
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
            keyboardType: TextInputType.number,
            validator: (value) => validateInputFloat(value, "dish price"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            controller: controllerType,
            decoration: const InputDecoration(
              hintText: 'Enter dish type',
              labelText: 'type',
            ),
            validator: (value) => validateInputNotEmpty(value, "dish type"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          TextFormField(
            controller: controllerType,
            decoration: const InputDecoration(
              hintText: 'Enter dish day',
              labelText: 'dish day',
            ),
            validator: (value) => validateInputNotEmpty(value, "dish day"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
            ),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              // if (_formKey.currentState!.validate()) {
                processInput();
              // }
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

  String? validateInputFloat(String? value, String label, {bool nonNegative = false}) {
    String? notEmptyValidate = validateInputNotEmpty(value, label);
    if (notEmptyValidate == null) {
      num? result = num.tryParse(value!);
      if (result == null) {
        return '$label must be an float';
      }
      else if (nonNegative && result < 0) {
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
      type: controllerType.value.text,
      dishDay: controllerDishDay.value.text,
      price: double.parse(controllerPrice.value.text),);
    dishService.createDish(currentCanteenInput);
    widget.callback(currentCanteenInput);
  }
}