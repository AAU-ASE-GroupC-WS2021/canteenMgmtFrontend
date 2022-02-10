import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class OrderSelectPickupTimeWidget extends StatefulWidget {
  final Function(DateTime) pickuptimeCallback;

  const OrderSelectPickupTimeWidget({
    Key? key,
    required this.pickuptimeCallback,
  }) : super(key: key);

  @override
  State<OrderSelectPickupTimeWidget> createState() =>
      _OrderSelectPickupTimeWidgetState();
}

class _OrderSelectPickupTimeWidgetState
    extends State<OrderSelectPickupTimeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DateTimePicker(
        type: DateTimePickerType.dateTime,
        dateMask: 'yyyy-MM-dd HH:mm',
        initialValue: initPickupDate().toString(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        dateLabelText: 'Select Pickup-Time',
        use24HourFormat: true,
        selectableDayPredicate: (date) {
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }
          return true;
        },
        onChanged: (val) {
          widget.pickuptimeCallback(DateTime.parse(val));
        },
      ),
    );
  }

  // set the date always to a weekday to prevent errors
  DateTime initPickupDate() {
    DateTime temp = DateTime.now();
    // weekday starts at 1 for monday -> 6 is saturday and 7 is sunday
    if (temp.weekday == 6) {
      temp = temp.add(const Duration(days: 2));
    } else if (temp.weekday == 7) {
      temp = temp.add(const Duration(days: 1));
    } else {
      temp = temp.add(const Duration(hours: 1));
    }
    return temp;
  }
}
