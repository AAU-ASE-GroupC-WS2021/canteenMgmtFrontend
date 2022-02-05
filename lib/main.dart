import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/screens/menu_service_demo.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'services/dish_service.dart';
import 'services/signup_service.dart';

void main() {
  GetIt.I.registerFactory<DishService>(() => DishService());

  // remove .../#/... from url
  Beamer.setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const BeamPage(
              title: 'Canteen Management',
              child: HomeScreen(),
            ),
        '/dish': (context, state, data) => const BeamPage(
              title: 'Dish Demo',
              child: DishDemoScreen(),
            ),
        '/menu': (context, state, data) => const BeamPage(
          title: 'Menu Demo',
          child: MenuDemoScreen(),
        ),
        '/qr-demo': (context, state, data) => BeamPage(
              title: 'QR Scanner Demo',
              child: QrDemoScreen(scanValue: data is String? ? data : null),
            ),
        '/qr-scan': (context, state, data) => const BeamPage(
              title: 'Scan QR Code',
              child: QrScannerScreen(),
            ),
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
