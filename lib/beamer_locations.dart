import 'package:beamer/beamer.dart';

import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_finished.dart';
import 'screens/signup_screen.dart';

BeamerDelegate getBeamerDelegate() => BeamerDelegate(
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
          '/signup': (context, state, data) => const BeamPage(
                title: 'Create a new profile',
                child: SignupScreen(),
              ),
          '/signin': (context, state, data) => const BeamPage(
                title: 'Log in',
                child: SignInScreen(),
              ),
          '/signup/finished': (context, state, data) => const BeamPage(
                title: 'Profile creation confirmation',
                child: SignupFinishedScreen(),
              ),
        },
      ),
    );
