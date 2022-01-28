import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/order_demo.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state, data) => const HomeScreen(),
        '/dish': (context, state, data) => const DishDemoScreen(),
        '/order': (context, state, data) => const OrderDemoScreen(),
        '/qr-demo': (context, state, data) =>
            QrDemoScreen(scanValue: data is String? ? data : null),
        '/qr-scan': (context, state, data) => const QrScannerScreen(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routeInformationParser: BeamerParser(),
      routerDelegate: beamerDelegate,
    );
  }
}
