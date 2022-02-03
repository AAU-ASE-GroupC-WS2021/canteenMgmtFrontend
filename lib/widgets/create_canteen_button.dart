import 'package:canteen_mgmt_frontend/cubits/canteen_cubit.dart';
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/services/canteen_service.dart';
import 'package:get_it/get_it.dart';

import '../widgets/canteen_form.dart';
import 'package:flutter/material.dart';

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
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CanteenForm((canteen) => {
                    GetIt.I.get<CanteenService>().createCanteen(canteen)
                        .then((value) => {
                          Navigator.pop(context),
                          GetIt.I.get<CanteensCubit>().refresh(),
                        },)
                        .onError((error, stackTrace) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            ),
                        }),
                  },),
                ),
              );
            },
        );
      },
    );
  }
}
