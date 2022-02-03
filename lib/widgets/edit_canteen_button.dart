import 'package:canteen_mgmt_frontend/cubits/canteen_cubit.dart';
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/services/canteen_service.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:get_it/get_it.dart';

import '../widgets/canteen_form.dart';
import 'package:flutter/material.dart';

class EditCanteenButton extends StatelessWidget {
  const EditCanteenButton(this.canteen, {Key? key}) : super(key: key);

  final Canteen canteen;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Edit Canteen'),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CanteenForm((canteen) => {
                    GetIt.I.get<CanteenService>().updateCanteen(canteen)
                        .then((value) => {
                          Navigator.pop(context),
                          GetIt.I.get<CanteensCubit>().refresh(),
                        })
                        .onError((error, stackTrace) => {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      ),
                    }),
                  }, canteen: canteen,),
                ),
              );
            },
        );
      },
    );
  }
}