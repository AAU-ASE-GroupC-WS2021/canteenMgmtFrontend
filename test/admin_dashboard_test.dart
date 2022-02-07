import 'package:canteen_mgmt_frontend/cubits/canteens_state_cubit.dart';
import 'package:canteen_mgmt_frontend/cubits/filtered_users_cubit.dart';
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/models/user.dart';
import 'package:canteen_mgmt_frontend/screens/admin_dashboard.dart';
import 'package:canteen_mgmt_frontend/services/canteen_service.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'admin_dashboard_test.mocks.dart';
import 'test_utils.dart';

@GenerateMocks([OwnerUserService, CanteenService])
void main() {
  Widget testWidget = const MaterialApp(
    home: Scaffold(
      body: AdminDashboardScreen(),
    ),
  );

  const _canteens = [
    Canteen(name: "Canteen1", address: "SomeAddress1", numTables: 11, id: 1),
    Canteen(name: "Canteen2", address: "SomeAddress2", numTables: 22, id: 2),
    Canteen(name: "Canteen3", address: "SomeAddress3", numTables: 33, id: 3),
  ];

  const _users = [
    User(username: 'User1', type: UserType.ADMIN, canteenID: 1, id: 1),
    User(username: 'User2', type: UserType.ADMIN, canteenID: 1, id: 2),
    User(username: 'User3', type: UserType.ADMIN, canteenID: 2, id: 3),
    User(username: 'User4', type: UserType.ADMIN, canteenID: null, id: 4),
    User(username: 'User5', type: UserType.USER, canteenID: null, id: 5),
    User(username: 'User6', type: UserType.USER, canteenID: 3, id: 6),
  ];

  final userService = MockOwnerUserService();
  GetIt.I.registerSingleton<OwnerUserService>(userService);
  final canteenService = MockCanteenService();
  GetIt.I.registerSingleton<CanteenService>(canteenService);
  GetIt.I.registerLazySingleton<CanteensStateCubit>(() => CanteensStateCubit());
  GetIt.I.registerLazySingleton<FilteredUsersCubit>(() => FilteredUsersCubit());

  setUp(() {
    when(userService.getAllByType(any)).thenAnswer((i) async =>
        _users.where((u) => (u.type == i.positionalArguments[0])).toList());
    when(userService.getAllByTypeAndCanteen(any, any)).thenAnswer((i) async =>
        _users
            .where((u) => (u.type == i.positionalArguments[0] &&
                u.canteenID == i.positionalArguments[1]))
            .toList());
    when(canteenService.getCanteens()).thenAnswer((_) async => _canteens);
  });

  testWidgets(
    'When launched then all canteens and all users displayed',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      for (final canteen in _canteens) {
        expect(find.textContaining(canteen.name), findsWidgets);
        expect(find.textContaining(canteen.address), findsWidgets);
        expect(find.textContaining(canteen.numTables.toString()), findsWidgets);
      }

      for (final user in _users) {
        if (user.type == UserType.ADMIN) {
          expect(find.textContaining(user.username), findsWidgets);
        } else {
          expect(find.textContaining(user.username), findsNothing);
        }
      }
    },
  );

  testWidgets(
    'When no connection then error messages shown',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      const errorUsers = 'Failed to load users';
      const errorCanteens = 'Failed to load canteens';

      when(userService.getAllByType(any)).thenThrow(Exception(errorUsers));
      when(canteenService.getCanteens()).thenThrow(Exception(errorCanteens));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.textContaining(errorUsers), findsWidgets);
      expect(find.textContaining(errorCanteens), findsWidgets);
    },
  );

  testWidgets(
    'When add canteen clicked then show dialog',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add).at(0));
      await tester.pumpAndSettle();

      expect(find.textContaining('Create Canteen'), findsWidgets);
    },
  );

  testWidgets(
    'When add user clicked then show dialog',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add).at(1));
      await tester.pumpAndSettle();

      expect(find.textContaining('Create User'), findsWidgets);
    },
  );

  testWidgets(
    'When edit user clicked then show dialog',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit).last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Edit User'), findsWidgets);
    },
  );

  testWidgets(
    'When edit canteen clicked then show dialog',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Edit Canteen'), findsWidgets);
    },
  );

  testWidgets(
    'When select canteen then only corresponding admins displayed',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      final canteenToSelect = _canteens[0];

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      final listviewItem = find.textContaining(canteenToSelect.name);
      await tester.tap(listviewItem);
      await tester.pumpAndSettle();

      for (final user in _users) {
        if (user.type == UserType.ADMIN &&
            user.canteenID == canteenToSelect.id) {
          expect(find.textContaining(user.username), findsWidgets);
        } else {
          expect(find.textContaining(user.username), findsNothing);
        }
      }

      await tester.tap(listviewItem);
      await tester.pumpAndSettle();

      for (final user in _users) {
        if (user.type == UserType.ADMIN) {
          expect(find.textContaining(user.username), findsWidgets);
        } else {
          expect(find.textContaining(user.username), findsNothing);
        }
      }
    },
  );
}
