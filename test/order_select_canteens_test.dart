import 'package:canteen_mgmt_frontend/cubits/canteens_cubit.dart';
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/screens/order_select_canteen.dart';
import 'package:canteen_mgmt_frontend/services/canteen_service.dart';
import 'package:canteen_mgmt_frontend/services/key_value_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_select_canteens_test.mocks.dart';
import 'test_utils.dart';

@GenerateMocks([CanteenService])
void main() {
  GetIt.I.registerSingleton(KeyValueStore());
  GetIt.I.registerLazySingleton<http.Client>(() => http.Client());

  Widget testWidget = const MaterialApp(
    home: Scaffold(
      body: OrderSelectCanteenScreen(),
    ),
  );

  const _canteens = [
    Canteen(name: "Canteen1", address: "SomeAddress1", numTables: 11, id: 1),
    Canteen(name: "Canteen2", address: "SomeAddress2", numTables: 22, id: 2),
    Canteen(name: "Canteen3", address: "SomeAddress3", numTables: 33, id: 3),
  ];

  final canteenService = MockCanteenService();
  GetIt.I.registerSingleton<CanteenService>(canteenService);
  GetIt.I.registerLazySingleton<CanteensCubit>(() => CanteensCubit());

  setUp(() {
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
      }
    },
  );

  testWidgets(
    'When no connection then error messages shown',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      const errorCanteens = 'Failed to load canteens';

      when(canteenService.getCanteens()).thenThrow(Exception(errorCanteens));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.textContaining(errorCanteens), findsWidgets);
    },
  );
}
