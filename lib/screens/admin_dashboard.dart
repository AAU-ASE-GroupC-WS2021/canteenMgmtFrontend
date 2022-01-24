import 'package:canteen_mgmt_frontend/widgets/canteen_form.dart';
import 'package:canteen_mgmt_frontend/widgets/text_heading.dart';

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
  final CanteenService canteenService = CanteenService();
  late Future<List<Canteen>> futureCanteens;

  @override
  void initState() {
    super.initState();
    futureCanteens = canteenService.getCanteens();
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
                    const TextHeading('Canteens'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CanteenForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
