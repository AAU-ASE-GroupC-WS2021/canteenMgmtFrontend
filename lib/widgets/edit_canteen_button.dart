import 'package:canteen_mgmt_frontend/models/canteen.dart';

import '../widgets/canteen_form.dart';
import 'package:flutter/material.dart';

class EditCanteenButton extends StatelessWidget {
  const EditCanteenButton(this.callback, this.canteen, {Key? key}) : super(key: key);

  final Canteen canteen;
  final Function(Canteen) callback;

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
                    // close dialog if success
                    if (callback(canteen)) {
                      Navigator.pop(context),
                    },
                  }, canteen: canteen,),
                ),
              );
            },
        );
      },
    );
  }
}
