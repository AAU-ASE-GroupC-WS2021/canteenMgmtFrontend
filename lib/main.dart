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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'home',
      routes: {
        HomePage.route: (context) => const HomePage(),
        DishDemoPage.route: (context) => const DishDemoPage(),
        QrDemoPage.route: (context) => const QrDemoPage(),
        QrScannerPage.route: (context) => const QrScannerPage(),
      },
    );
  }
}
