import 'package:canteen_mgmt_frontend/models/canteen.dart';

import '../widgets/canteen_form.dart';
import 'package:flutter/material.dart';

class AddCanteenButton extends StatelessWidget {
  const AddCanteenButton(this.callback, {Key? key}) : super(key: key);

  final Function(Canteen) callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Canteen'),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CanteenForm((canteen) => {
                    // close dialog
                    Navigator.pop(context),
                    callback(canteen),
                  },),
                ),
              );
            },
        );
      },
    );
  }
}
