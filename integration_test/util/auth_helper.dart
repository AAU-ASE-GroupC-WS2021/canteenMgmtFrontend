import 'package:canteen_mgmt_frontend/models/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Log in with passed credentials.
/// This function assumes a pumped and settled home page and
/// ends on a pumped and settled home page.
Future<void> logIn(WidgetTester tester, Signup credentials) async {
  await tester.tap(find.textContaining('Log in'));
  await tester.pumpAndSettle();

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), credentials.username);
  await tester.enterText(textField.at(1), credentials.password);

  await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
  await tester.pumpAndSettle();

  expect(find.textContaining(credentials.username), findsOneWidget);
}

/// Sign up with passed credentials.
/// This function assumes a pumped and settled home page and
/// ends on a pumped and settled home page.
Future<void> signUp(WidgetTester tester, Signup credentials) async {
  await tester.tap(find.textContaining('Sign up'));
  await tester.pumpAndSettle();

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), credentials.username);
  await tester.enterText(textField.at(1), credentials.password);

  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  expect(find.textContaining('Profile created successfully'), findsOneWidget);

  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}
