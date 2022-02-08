import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';

import 'screens/admin_dashboard.dart';
import 'screens/admin_dashboard.dart';
import 'screens/create_order.dart';
import 'screens/dish_service_demo.dart';
import 'screens/home.dart';
import 'screens/menu_service_demo.dart';
import 'screens/my_orders.dart';
import 'screens/order_select_canteen.dart';
import 'screens/qr_demo.dart';
import 'screens/qr_scanner.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_finished.dart';
import 'screens/signup_screen.dart';
import 'screens/single_order.dart';

//ignore:long-method
BeamerDelegate getBeamerDelegate() => BeamerDelegate(
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
        },
      ),
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
