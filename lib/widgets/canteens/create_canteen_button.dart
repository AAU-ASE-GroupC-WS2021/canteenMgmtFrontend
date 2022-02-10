import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/canteens_cubit.dart';
import '../../services/canteen_service.dart';
import 'canteen_form.dart';

class CreateCanteenButton extends StatelessWidget {
  const CreateCanteenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Create Canteen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CanteenForm(
                      (canteen) {
                        GetIt.I
                            .get<CanteenService>()
                            .createCanteen(canteen)
                            .then(
                          (value) {
                            Navigator.pop(context);
                            GetIt.I.get<CanteensCubit>().refresh();
                          },
                        ).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
