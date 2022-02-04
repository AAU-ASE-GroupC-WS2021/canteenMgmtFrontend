import 'package:beamer/beamer.dart';
import 'cubits/canteen_cubit.dart';
import 'cubits/filtered_users_cubit.dart';
import 'services/owner_user_service.dart';
import 'services/canteen_service.dart';
import 'screens/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'services/dish_service.dart';

MyApp main() {
  if (!GetIt.I.isRegistered<DishService>()) GetIt.I.registerFactory<DishService>(() => DishService());
  if (!GetIt.I.isRegistered<CanteenService>()) GetIt.I.registerFactory<CanteenService>(() => CanteenService());
  if (!GetIt.I.isRegistered<OwnerUserService>()) GetIt.I.registerFactory<OwnerUserService>(() => OwnerUserService());
  if (!GetIt.I.isRegistered<CanteensCubit>()) GetIt.I.registerLazySingleton<CanteensCubit>(() => CanteensCubit());
  if (!GetIt.I.isRegistered<FilteredUsersCubit>()) GetIt.I.registerLazySingleton<FilteredUsersCubit>(() => FilteredUsersCubit());

  var app = MyApp();
  runApp(app);

  return app;
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
        '/qr-demo': (context, state, data) => BeamPage(
              title: 'QR Scanner Demo',
              child: QrDemoScreen(scanValue: data is String? ? data : null),
            ),
        '/qr-scan': (context, state, data) => const BeamPage(
              title: 'Scan QR Code',
              child: QrScannerScreen(),
            ),
        '/admin': (context, state, data) => const BeamPage(
              title: 'Admin Dashboard',
              child: AdminDashboardScreen(),
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
