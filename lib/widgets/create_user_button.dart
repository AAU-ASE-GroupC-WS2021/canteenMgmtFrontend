import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/canteen.dart';
import '../services/canteen_service.dart';
import 'create_user_form.dart';

class CreateUserButton extends StatefulWidget {
  const CreateUserButton({Key? key, this.defaultCanteen}) : super(key: key);

  final Canteen? defaultCanteen;

  @override
  State<CreateUserButton> createState() => _CreateUserButtonState();
}

class _CreateUserButtonState extends State<CreateUserButton> {
  final CanteenService canteenService = GetIt.I<CanteenService>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        canteenService.getCanteens().then((allCanteens) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create User'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: CreateUserForm(
                        canteens: allCanteens,
                        defaultCanteen: widget.defaultCanteen,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}
