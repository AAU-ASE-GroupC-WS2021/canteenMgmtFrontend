import 'package:beamer/beamer.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/order_data_helper_service.dart';

class OrderSelectParameterScreen extends StatefulWidget {
  final int canteenId;

  const OrderSelectParameterScreen({
    Key? key,
    required this.canteenId,
  }) : super(key: key);

  @override
  State<OrderSelectParameterScreen> createState() =>
      _OrderSelectParameterState();
}

class _OrderSelectParameterState extends State<OrderSelectParameterScreen> {
  final OrderDataHelperService orderDataHelperService =
      GetIt.I<OrderDataHelperService>();
  late DateTime selectedPickupTime = initPickupDate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Define Order parameters'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Container(
              width: 300,
              child: DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'yyyy-MM-dd HH:mm',
                initialValue: selectedPickupTime.toString(),
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
                  selectedPickupTime = DateTime.parse(val);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            getSubmitWidget(context),
          ],
        ),
      ),
    );
  }

  getSubmitWidget(BuildContext context) {
    const TextStyle warningStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );
    if (selectedPickupTime
        .isBefore(DateTime.now().add(const Duration(hours: 1)))) {
      return const Text(
        'Pickup must be at least 1 hour from now!',
        style: warningStyle,
      );
    } else if (selectedPickupTime.hour < 9 || selectedPickupTime.hour > 17) {
      return const Text(
        'Canteens are only open between 09:00 and 17:00',
        style: warningStyle,
      );
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.add_chart_rounded),
        onPressed: () {
          orderDataHelperService.setOrderArguments(
            widget.canteenId,
            selectedPickupTime,
            false,
          );
          context.beamToNamed('/order-select-dishes', beamBackOnPop: true);
        },
      );
    }
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
