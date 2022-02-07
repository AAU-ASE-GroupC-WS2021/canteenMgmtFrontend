import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/models/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/auth_helper.dart';
import 'util/widget_tester_wait_for.dart';

const _userCredentials = Signup(
  username: 'SomeTestUser',
  password: 'SomeTestPassword123',
);

const _exampleDish = Dish(name: 'Some Test Dish', price: 123, type: 'MAIN');

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("demo test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Canteen Management'), findsOneWidget);

    await signUp(tester, _userCredentials);
    await logIn(tester, _userCredentials);

    await tester.tap(find.text('Dish Service Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text('Create Dish'), findsOneWidget);
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

    await tester.tap(find.text('Create Dish').hitTestable().last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();

    // expect(find.text(_exampleDish.name), findsWidgets);
    await tester.waitFor(find.text(_exampleDish.name));
    expect(find.text(_exampleDish.name), findsWidgets);

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
