import '../models/user.dart';
import '../services/canteen_service.dart';
import 'edit_user_form.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

class EditUserButton extends StatefulWidget {
  const EditUserButton(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  State<EditUserButton> createState() => _EditUserButtonState();
}

class _EditUserButtonState extends State<EditUserButton> {
  final CanteenService canteenService = GetIt.I<CanteenService>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        canteenService.getCanteens().then((allCanteens) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Edit User'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: EditUserForm(
                            canteens: allCanteens,
                            user: widget.user,
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
