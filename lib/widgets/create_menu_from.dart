import '../models/menu.dart';

import '../services/menu_service.dart';

import '../services/dish_service.dart';
import 'package:flutter/services.dart';
import '../models/dish.dart';
import 'package:flutter/material.dart';

class CreateMenuForm extends StatefulWidget {
  const CreateMenuForm(this.callback, {Key? key, this.menu}) : super(key: key);

  final Menu? menu;
  final Function(Menu) callback;

  @override
  State<StatefulWidget> createState() => _CreateMenuFormState();
}

class _CreateMenuFormState extends State<CreateMenuForm> {
  final _formKey = GlobalKey<FormState>();
  static const spacing = 15.0;
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  String _menuDayValue = 'NOMENUDAY';
  final controllerMenuDishNames = TextEditingController();

  final MenuService menuService = MenuService(); //GetIt.I<MenuService>();
  final _menuDays = [
    "NOMENUDAY",
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
  ];

  List<String> menuDishNames = [];

  final List<String> _selectedItems = [];

  // This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  Future<void> _changeAvailableDishes(String newValue) async {
    menuDishNames =[];
    var dishList = await DishService().fetchDishes(newValue);
    for (Dish element in dishList) {
      // print(element.name);
      menuDishNames.insert(0, element.name);
    }
  }

   bool checkDishSelection(){
    if (_selectedItems.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(
            content: Text("At least one dish must be selected"),
          ),);
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menu != null) {
      controllerName.text = widget.menu!.name;
      controllerMenuDishNames.text = widget.menu!.menuDishNames.toString();
      _menuDayValue = widget.menu!.menuDay;
      controllerPrice.text = widget.menu!.price.toString();
    }
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
          TextFormField(
            controller: controllerPrice,
            decoration: const InputDecoration(
              hintText: 'Enter price of menu',
              labelText: 'price',
            ),
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            validator: (value) => validateInputFloat(value, "menu price"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: spacing),

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
                isEmpty: _menuDayValue == ' ',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _menuDayValue,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        _menuDayValue = newValue.toString();
                        state.didChange(newValue);
                        _changeAvailableDishes(newValue.toString());
                      });
                    },
                    items: _menuDays.map((String value) {
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
          StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Select Dishes'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: menuDishNames
                        .map((item) => CheckboxListTile(
                              value: _selectedItems.contains(item),
                              title: Text(item),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isChecked) =>
                                  _itemChange(item, isChecked!),
                            ))
                        .toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  // ElevatedButton(
                  //   child: const Text('Save Dishes'),
                  //   onPressed: _submit(),
                  // ),
                ],
              );
            },
          ),

          // till here
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
                if (checkDishSelection()) {
                  processInput();
                }
              }
            },
            child: const Text("Create Menu"),
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
    var id = widget.menu != null ? widget.menu!.id : -1;
    Menu menu = Menu(
      id: id,
      name: controllerName.value.text,
      menuDishNames: _selectedItems,
      menuDay: _menuDayValue,
      price: double.parse(controllerPrice.value.text),
    );
    widget.callback(menu);
  }
}
