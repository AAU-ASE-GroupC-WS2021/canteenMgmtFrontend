import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/auth.dart';
import 'screens/canteens/admin_dashboard.dart';
import 'screens/dish_mgmt.dart';
import 'screens/home.dart';
import 'screens/menu_mgmt.dart';
import 'screens/orders/create_order.dart';
import 'screens/orders/my_orders.dart';
import 'screens/orders/order_qr_scan.dart';
import 'screens/orders/order_select_canteen.dart';
import 'screens/orders/single_order.dart';
import 'screens/users/password_finished.dart';
import 'screens/users/profile_mgmt_screen.dart';
import 'screens/users/pw_change_screen.dart';
import 'screens/users/signin_screen.dart';
import 'screens/users/signup_finished.dart';
import 'screens/users/signup_screen.dart';

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
                title: 'Dish Management',
                child: DishMgmtScreen(),
                key: ValueKey('DishScreen'),
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
          '/profile': (context, state, data) => const BeamPage(
                child: ProfileManagementScreen(),
                title: 'Profile creation confirmation',
              ),
          '/profile/password': (context, state, data) => const BeamPage(
                child: PwChangeScreen(),
                title: 'Change password',
              ),
          '/profile/password/changed': (context, state, data) => const BeamPage(
                child: PasswordFinishedScreen(),
                title: 'Password changed',
              ),
          '/admin': (context, state, data) => const BeamPage(
                title: 'Admin Dashboard',
                child: AdminDashboardScreen(),
                key: ValueKey('AdminDashboardScreen'),
              ),
          '/menu': (context, state, data) => const BeamPage(
                title: 'Menu Management',
                child: MenuMgmtScreen(),
                key: ValueKey('MenuMgmtScreen'),
              ),
          '/order': (context, state, data) => const BeamPage(
                title: 'My Orders',
                key: ValueKey('my-orders'),
                child: MyOrdersScreen(),
              ),
          '/order/:orderId': (context, state, data) =>
              singleOrderScreen(context, state, data),
          '/order-select-canteen': (context, state, data) => const BeamPage(
                title: 'Start a new Order',
                child: OrderSelectCanteenScreen(),
              ),
          '/create-order/:canteenId': (context, state, data) =>
              orderSelectDishesScreen(context, state, data),
          '/scan-order': (context, state, data) => const BeamPage(
                title: 'Scan QR Code',
                child: OrderQrScanScreen(),
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

/*
 * helper method to reduce bloat in the BeamerDelegate function, intializesthe BeamPage
 * for the ParameterSelection for the orders
 */
orderSelectDishesScreen(BuildContext context, BeamState state, Object? data) {
  var canteenId = int.tryParse(state.pathParameters['canteenId']!);
  if (canteenId == null) {
    context.popToNamed('/order-select-canteen');
    return const SizedBox();
  }
  return BeamPage(
    // the key is required for flutter to differentiate between similar widgets.
    // necessary, if multiple different widgets of the same type are used in the same place in the widget tree.
    key: ValueKey('canteenId-$canteenId'),
    title: 'Order from Canteen',
    child: CreateOrderScreen(canteenId: canteenId),
  );
}

/*
 * helper method to reduce bloat in the BeamerDelegate function, intializesthe BeamPage
 * for the OrderScreen
 */
singleOrderScreen(context, state, data) {
  var orderId = int.tryParse(state.pathParameters['orderId']!);
  if (orderId == null) {
    context.beamToNamed('/order');
    return const SizedBox();
  }
  return BeamPage(
    // the key is required for flutter to differentiate between similar widgets.
    // necessary, if multiple different widgets of the same type are used in the same place in the widget tree.
    key: ValueKey('order-$orderId'),
    title: 'Order-$orderId',
    child: SingleOrderScreen(orderId: orderId),
  );
}
