import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/models/user.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:canteen_mgmt_frontend/widgets/edit_user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_user_form_test.mocks.dart';

@GenerateMocks([OwnerUserService])
void main() {
  const List<Canteen> _canteens = [
    Canteen(name: "Canteen1", address: "SomeAddress", numTables: 42, id: 1),
    Canteen(name: "Canteen2", address: "SomeAddress", numTables: 42, id: 2),
    Canteen(name: "Canteen3", address: "SomeAddress", numTables: 42, id: 3),
  ];

  const _defaultCanteenIndex = 1;
  User _defaultUser = User(
    username: "username",
    type: UserType.ADMIN,
    id: 1,
    canteenID: _canteens[_defaultCanteenIndex].id,
    password: "password",
  );

  Widget testWidget = MaterialApp(
    home: Scaffold(
      body: EditUserForm(
        canteens: _canteens,
        user: _defaultUser,
      ),
    ),
  );

  String _getTextFromTextFormInputAt(int index) {
    return (find.byType(TextFormField).at(index).evaluate().single.widget
            as TextFormField)
        .controller!
        .value
        .text;
  }

  MockOwnerUserService userService = MockOwnerUserService();

  setUp(() {
    userService = MockOwnerUserService();
    GetIt.I.registerSingleton<OwnerUserService>(userService);
  });

  tearDown(() {
    GetIt.I.unregister<OwnerUserService>();
  });

  testWidgets('Check if elements are there and populated correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    expect(_getTextFromTextFormInputAt(0), _defaultUser.username);
    expect(
        (find.byType(CheckboxListTile).evaluate().single.widget
                as CheckboxListTile)
            .value,
        false,);
    expect(
      (find.byKey(const ValueKey('dropdown')).evaluate().single.widget
              as FormBuilderDropdown)
          .initialValue,
      _canteens[_defaultCanteenIndex],
    );

    // select "change password"
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(_getTextFromTextFormInputAt(1), "");
    expect(_getTextFromTextFormInputAt(2), "");
  },);

  testWidgets(
      'When nothing changed and button pressed then submit correct data',
      (WidgetTester tester) async {
    User? submittedUser;
    when(userService.updateUser(any))
        .thenAnswer((i) async => (submittedUser = i.positionalArguments[0]));

    await tester.pumpWidget(testWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(userService.updateUser(any)).called(1);
    expect(submittedUser!.id, _defaultUser.id);
    expect(submittedUser!.username, _defaultUser.username);
    expect(submittedUser!.password, null);
    expect(submittedUser!.canteenID, _defaultUser.canteenID);
  },);

  testWidgets(
      'When non-matching passwords entered and button pressed then no submit',
      (WidgetTester tester) async {
    when(userService.updateUser(any))
        .thenAnswer((i) async => i.positionalArguments[0]);

    await tester.pumpWidget(testWidget);
    // select "change password"
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), "password1");
    await tester.enterText(find.byType(TextFormField).at(2), "password2");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verifyNever(userService.updateUser(any));
  },);

  testWidgets(
      'When matching passwords entered and button pressed then submit correct data',
      (WidgetTester tester) async {
    User? submittedUser;
    when(userService.updateUser(any))
        .thenAnswer((i) async => (submittedUser = i.positionalArguments[0]));

    await tester.pumpWidget(testWidget);
    // select "change password"
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(1), _defaultUser.password!,);
    await tester.enterText(
        find.byType(TextFormField).at(2), _defaultUser.password!,);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(userService.updateUser(any)).called(1);
    expect(submittedUser!.id, _defaultUser.id);
    expect(submittedUser!.username, _defaultUser.username);
    expect(submittedUser!.password, _defaultUser.password!);
    expect(submittedUser!.canteenID, _defaultUser.canteenID);
  },);
}
