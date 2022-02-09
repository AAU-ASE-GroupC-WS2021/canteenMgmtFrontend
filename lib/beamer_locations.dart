import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/cubits/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/admin_dashboard.dart';
import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/menu_service_demo.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_finished.dart';
import 'screens/signup_screen.dart';

//ignore:long-method
BeamerDelegate getBeamerDelegate() => BeamerDelegate(
      initialPath: '/',
      notFoundRedirectNamed: '/',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/': (context, state, data) => const BeamPage(
                title: 'Canteen Management',
                child: HomeScreen(),
                key: ValueKey('HomeScreen'),
              ),
          '/dish': (context, state, data) => const BeamPage(
                title: 'Dish Demo',
                child: DishDemoScreen(),
                key: ValueKey('DishScreen'),
              ),
          '/qr-demo': (context, state, data) => BeamPage(
                title: 'QR Scanner Demo',
                child: QrDemoScreen(scanValue: data is String? ? data : null),
                key: ValueKey('QRDemoScreen'),
              ),
          '/qr-scan': (context, state, data) => const BeamPage(
                title: 'Scan QR Code',
                child: QrScannerScreen(),
                key: ValueKey('QRScannerScreen'),
              ),
          '/signup': (context, state, data) => const BeamPage(
                title: 'Create a new profile',
                child: SignupScreen(),
                key: ValueKey('SignupScreen'),
              ),
          '/signin': (context, state, data) => const BeamPage(
                title: 'Log in',
                child: SignInScreen(),
                key: ValueKey('SignInScreen'),
              ),
          '/signup/finished': (context, state, data) => const BeamPage(
                title: 'Profile creation confirmation',
                child: SignupFinishedScreen(),
                key: ValueKey('SignupFinishedScreen'),
              ),
          '/admin': (context, state, data) => const BeamPage(
                title: 'Admin Dashboard',
                child: AdminDashboardScreen(),
                key: ValueKey('AdminDashboardScreen'),
              ),
          '/menu': (context, state, data) => const BeamPage(
                title: 'Menu Demo',
                child: MenuDemoScreen(),
                key: ValueKey('MenuDemoScreen'),
              ),
        },
      ),
      guards: [
        // secure all routes except base and login/registration related
        BeamGuard(
          guardNonMatching: true, // guard all routes except the following
          pathPatterns: ['/', '/sign*'],
          check: (context, beamLocation) =>
              context.read<AuthCubit>().state.authenticated,
          beamToNamed: (from, to) => '/signin',
        ),
        // redirect away from login/registration pages when already logged in
        BeamGuard(
          pathPatterns: ['/sign*'],
          check: (context, beamLocation) =>
              !context.read<AuthCubit>().state.authenticated,
          beamToNamed: (from, to) => '/',
        ),
        // give only staff and owners access to management
        BeamGuard(
          pathPatterns: ['/dish', '/menu', '/scan-order'],
          check: (context, beamLocation) =>
              {'ADMIN', 'OWNER'}.contains(context.read<AuthCubit>().state.type),
          beamToNamed: (from, to) => '/',
          onCheckFailed: (context, beamLocation) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You are not allowed to access this.'),
            ));
          },
        ),
        // only owners can access the canteen management panel
        BeamGuard(
          pathPatterns: ['/admin'],
          check: (context, beamLocation) =>
              context.read<AuthCubit>().state.type == 'OWNER',
          beamToNamed: (from, to) => '/',
          onCheckFailed: (context, beamLocation) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You are not allowed to access this.'),
            ));
          },
        ),
      ],
    );
