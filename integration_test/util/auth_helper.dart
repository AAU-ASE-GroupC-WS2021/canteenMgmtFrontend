import 'package:canteen_mgmt_frontend/models/users/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_tester_tap_and_wait.dart';

/// Log in with passed credentials.
/// This function assumes a pumped and settled home page and
/// ends on a pumped and settled home page.
Future<void> logIn(WidgetTester tester, Signup credentials) async {
  await tester.tapAndWait(find.textContaining('Log in'));

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), credentials.username);
  await tester.enterText(textField.at(1), credentials.password);

  await tester.tapAndWait(
    find.widgetWithText(ElevatedButton, 'Log in'),
    waitUntil: find.text('Canteen Management'),
    timeout: const Duration(seconds: 10),
  );

  expect(find.textContaining(credentials.username), findsOneWidget);
}

/// Sign up with passed credentials.
/// This function assumes a pumped and settled home page and
/// ends on a pumped and settled home page.
Future<void> signUp(WidgetTester tester, Signup credentials) async {
  await tester.tapAndWait(find.textContaining('Sign up'));

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), credentials.username);
  await tester.enterText(textField.at(1), credentials.password);

  await tester.tapAndWait(
    find.byType(ElevatedButton),
    waitUntil: find.text('Profile created successfully.'),
    timeout: const Duration(seconds: 10),
  );

  await tester.tapAndWait(find.byType(ElevatedButton));
}
