import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../cubits/canteens_state_cubit.dart';
import '../models/canteen.dart';
import '../services/canteen_service.dart';
import '../widgets/canteen_form.dart';

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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: CanteenForm((canteen) => {
                        GetIt.I
                            .get<CanteenService>()
                            .updateCanteen(canteen)
                            .then((value) => {
                                  Navigator.pop(context),
                                  GetIt.I.get<CanteensStateCubit>().refresh(),
                                })
                            .onError((error, stackTrace) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          ),
                        }),
                      }, canteen: canteen,),
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
