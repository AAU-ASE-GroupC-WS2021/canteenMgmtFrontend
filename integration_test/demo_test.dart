import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/models/users/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/auth_helper.dart';
import 'util/widget_tester_tap_and_wait.dart';

const _adminCredentials = Signup(
  username: 'adminUsername',
  password: 'adminPassword123',
);

const _exampleDish = Dish(name: 'Some Test Dish', price: 123, type: 'MAIN');

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("demo test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Canteen Management'), findsOneWidget);

    await logIn(tester, _adminCredentials);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dish Management').first);
    await tester.pumpAndSettle();

    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text(_exampleDish.name), findsNothing);

    await tester.tap(find.text('Create Dish'));
    await tester.pumpAndSettle();

    var textField = find.byType(TextFormField);
    await tester.enterText(textField.at(0), _exampleDish.name);
    await tester.enterText(textField.at(1), '${_exampleDish.price}');

    await tester.tap(find.text('NOMENUDAY').hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('MONDAY').hitTestable());
    await tester.pumpAndSettle();

    await tester.tapAndWait(
      find.ancestor(
        of: find.widgetWithText(ElevatedButton, 'Create Dish'),
        matching: find.byType(Form),
      ),
      waitUntil: find.byType(Form),
      isNoLongerVisible: true,
    );

    await tester.tapAndWait(
      find.text('Refresh'),
      waitUntil: find.text(_exampleDish.name),
    );

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
