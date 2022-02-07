import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/models/signup.dart';
import 'package:canteen_mgmt_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/auth_helper.dart';

const _ownerCredentials = Signup(
  username: 'owner',
  password: 'defaultownerpassword',
);

const _canteenToCreate = Canteen(
  name: "TestCanteen",
  address: "TestAddress",
  numTables: 40,
);

const _userToCreate = User(
  username: "MyUsername",
  password: "MyPassword123",
  type: UserType.ADMIN,
);

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Admin Dashboard test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await logIn(tester, _ownerCredentials);

    await _homeToAdminDashboard(tester);

    await _createCanteen(tester, _canteenToCreate);
    await _verifyCanteenIsDisplayed(tester, _canteenToCreate);

    await _toggleCanteenSelection(tester, _canteenToCreate);
    await _verifyCanteenHasNoUsers(tester, _canteenToCreate);

    await _createUser(tester, _userToCreate);
    await _verifyUserIsDisplayed(tester, _userToCreate);

    await _toggleCanteenSelection(tester, _canteenToCreate);
    await _verifyUserIsDisplayed(tester, _userToCreate);
  });
}

Future<void> _createUser(WidgetTester tester, User user) async {
  await tester.tap(find.byIcon(Icons.add).last);
  await Future.value(1).timeout(const Duration(seconds: 3));
  await tester.pumpAndSettle();

  expect(find.text('Create User'), findsWidgets);

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), user.username);
  await tester.enterText(textField.at(1), user.password!);
  await tester.enterText(textField.at(2), user.password!);

  await tester.tap(find.byType(ElevatedButton).first);
  await Future.value(1).timeout(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

Future<void> _verifyCanteenHasNoUsers(
    WidgetTester tester, Canteen canteen,) async {
  expect(find.textContaining('[filtered]'), findsWidgets);
  expect(find.textContaining('No users currently'), findsWidgets);
}

Future<void> _toggleCanteenSelection(
    WidgetTester tester, Canteen canteen,) async {
  await tester.tap(find.text(canteen.name).first);
  await tester.pumpAndSettle();
}

Future<void> _homeToAdminDashboard(WidgetTester tester) async {
  await tester.tap(find.text('Admin Dashboard').first);
  await tester.pumpAndSettle();
  expect(find.text('Canteens'), findsWidgets);
}

Future<void> _verifyCanteenIsDisplayed(
    WidgetTester tester, Canteen canteen,) async {
  expect(find.text(canteen.name), findsWidgets);
  expect(find.textContaining(canteen.address), findsWidgets);
}

Future<void> _verifyUserIsDisplayed(WidgetTester tester, User user) async {
  expect(find.text(user.username), findsWidgets);
}

Future<void> _createCanteen(WidgetTester tester, Canteen canteen) async {
  await tester.tap(find.byIcon(Icons.add).first);
  await tester.pumpAndSettle();
  expect(find.text('Create Canteen'), findsWidgets);

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), canteen.name);
  await tester.enterText(textField.at(1), canteen.address);
  await tester.enterText(textField.at(2), canteen.numTables.toString());

  await tester.tap(find.byType(ElevatedButton).first);
  await Future.value(1).timeout(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}
