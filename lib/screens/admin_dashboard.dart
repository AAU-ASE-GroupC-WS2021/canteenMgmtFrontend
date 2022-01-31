import 'package:canteen_mgmt_frontend/widgets/create_user_button.dart';
import 'package:get_it/get_it.dart';

import '../widgets/create_canteen_button.dart';
import '../widgets/text_heading.dart';

import '../widgets/canteen_table.dart';
import '../models/canteen.dart';
import '../services/canteen_service.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final CanteenService canteenService = GetIt.I<CanteenService>();
  late Future<List<Canteen>> futureCanteens;

  @override
  void initState() {
    super.initState();
    futureCanteens = canteenService.getCanteens();
  }

  bool createCanteen(Canteen c) {
    // TODO: add API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(c.toString())),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 32.0),
                          const TextHeading('Canteens'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CreateCanteenButton(createCanteen),
                              CreateUserButton(() => {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: FutureBuilder<List<Canteen>>(
                          future: futureCanteens,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CanteenTable(canteens: snapshot.data!, showId: true,);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            } else {
                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final newCanteens = canteenService.getCanteens();
                        setState(() {
                          futureCanteens = newCanteens;
                        });
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
