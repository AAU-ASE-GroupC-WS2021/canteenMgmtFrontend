import 'package:flutter/material.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // more sophisticated routing consider using packages like yeet or beamer
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => const HomeScreen(),
        DishDemoScreen.route: (context) => const DishDemoScreen(),
        QrDemoScreen.route: (context) => const QrDemoScreen(),
        QrScannerScreen.route: (context) => const QrScannerScreen(),
      },
    );
  }
}
