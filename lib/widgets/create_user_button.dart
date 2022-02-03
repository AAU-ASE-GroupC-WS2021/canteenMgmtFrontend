import 'package:canteen_mgmt_frontend/models/canteen.dart';

import '../models/user.dart';

import '../services/canteen_service.dart';
import 'create_user_form.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';

class CreateUserButton extends StatefulWidget {
  CreateUserButton(this.callback, this.defaultCanteen, {Key? key}) : super(key: key);

  final Function(User) callback;
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
        canteenService.getCanteens().then((allCanteens) => {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create User'),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CreateUserForm((canteen) => {
                    // close dialog if success
                    if (widget.callback(canteen)) {
                      Navigator.pop(context),
                    },
                  }, canteens: allCanteens, defaultCanteen: widget.defaultCanteen,),
                ),
              );
            },
          ),
        });
      },
    );
  }
}
