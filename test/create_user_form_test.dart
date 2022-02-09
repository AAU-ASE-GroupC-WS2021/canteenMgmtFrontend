import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/models/user.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:canteen_mgmt_frontend/widgets/create_user_form.dart';
import 'package:flutter/material.dart';
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
    password: "mySuperSophisticatedP4SSW0RD",
  );

  Widget testWidget = const MaterialApp(
    home: Scaffold(
      body: CreateUserForm(canteens: _canteens),
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

  testWidgets('Check if elements are there', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(_getTextFromTextFormInputAt(0), "");
    expect(_getTextFromTextFormInputAt(1), "");
    expect(_getTextFromTextFormInputAt(2), "");
  });

  testWidgets(
    'When fields empty and button pressed then no submit',
    (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(); // wait until error messages are displayed

      verifyNever(userService.createUser(any));
    },
  );

  testWidgets(
    'When fields filled in (no canteen) and button pressed then submit correct data',
    (WidgetTester tester) async {
      User? createdUser;
      when(userService.createUser(any))
          .thenAnswer((i) async => (createdUser = i.positionalArguments[0]));

      await tester.pumpWidget(testWidget);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        _defaultUser.username,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        _defaultUser.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        _defaultUser.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(userService.createUser(any)).called(1);
      expect(createdUser!.username, _defaultUser.username);
      expect(createdUser!.password, _defaultUser.password);
      expect(createdUser!.canteenID, null);
    },
  );

  testWidgets(
    'When fields filled in (with canteen) and button pressed then submit correct data',
    (WidgetTester tester) async {
      User? createdUser;
      when(userService.createUser(any))
          .thenAnswer((i) async => (createdUser = i.positionalArguments[0]));

      await tester.pumpWidget(testWidget);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        _defaultUser.username,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        _defaultUser.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        _defaultUser.password!,
      );

      // select canteen in dropdown
      final dropdown = find.byKey(const ValueKey('dropdown'));
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      final dropdownItem =
          find.text(_canteens[_defaultCanteenIndex].toString()).last;
      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(userService.createUser(any)).called(1);
      expect(createdUser!.username, _defaultUser.username);
      expect(createdUser!.password, _defaultUser.password);
      expect(createdUser!.canteenID, _canteens[_defaultCanteenIndex].id);
    },
  );
}
