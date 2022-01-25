import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/screens/signup_finished.dart';
import 'package:canteen_mgmt_frontend/screens/signup_screen.dart';
import 'package:flutter/material.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'screens/signup_screen.dart';


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
        '/signup': (context, state, data) => const SignupScreen(),
        '/signup-finished': (context, state, data) => const SignupFinishedScreen(),
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
