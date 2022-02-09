import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/models/order.dart';
import 'package:canteen_mgmt_frontend/models/signup.dart';
import 'package:canteen_mgmt_frontend/widgets/qr_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/auth_helper.dart';
import 'util/screenshot_helper.dart';
import 'util/widget_tester_tap_and_wait.dart';

const _user = Signup(username: 'QrUser', password: 'QrUserPass1');
const _staff = Signup(username: 'QrStaff', password: 'QrStaffPass1');
const _dish = Dish(name: 'QR Dish', price: 123, type: 'MAIN');
final _order = Order(
  canteenId: 1,
  userId: 3,
  dishes: {_dish: 3},
  pickupDate: DateTime.fromMillisecondsSinceEpoch(1644323114),
  reserveTable: false,
);

// allow running this test by itself
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Generate QR Code", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Canteen Management'), findsOneWidget);

    await logIn(tester, _user);

    await tester.tapAndWait(
      find.text('Your Orders'),
      waitUntil: find.textContaining('Order at '),
    );

    await tester.tapAndWait(
      find.byIcon(Icons.qr_code),
      waitUntil: find.byType(QrCodeDisplay),
    );

    expect(find.byType(QrCodeDisplay), findsOneWidget);

    if (const String.fromEnvironment('SCREENSHOT').isNotEmpty) {
      screenshot(binding, tester, name: 'qr-code');

      // to prevent the text from ending before the screenshot is taken
      await Future.delayed(const Duration(seconds: 5));
      expect(find.byType(QrCodeDisplay), findsOneWidget);

      return;
    }

    // TODO scan code
  });
}
