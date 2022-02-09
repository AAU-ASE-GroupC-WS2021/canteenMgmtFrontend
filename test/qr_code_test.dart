import 'dart:async';

import 'package:canteen_mgmt_frontend/cubits/order_cubit.dart';
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/models/order.dart';
import 'package:canteen_mgmt_frontend/screens/my_orders.dart';
import 'package:canteen_mgmt_frontend/services/key_value_store.dart';
import 'package:canteen_mgmt_frontend/services/order_qr_code.dart';
import 'package:canteen_mgmt_frontend/widgets/qr_display.dart';
import 'package:canteen_mgmt_frontend/widgets/qr_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'qr_code_test.mocks.dart';

final _order = Order(
  id: 1234,
  canteenId: 1,
  userId: 1,
  dishes: const {Dish(name: 'QR Dish', price: 123, type: 'MAIN'): 2},
  pickupDate: DateTime.now().add(const Duration(hours: 2)),
  reserveTable: false,
);

final _orderNoId = Order(
  canteenId: 1,
  userId: 1,
  dishes: const {Dish(name: 'QR Dish', price: 123, type: 'MAIN'): 2},
  pickupDate: DateTime.now().add(const Duration(hours: 2)),
  reserveTable: false,
);

@GenerateMocks([OrderCubit])
void main() {
  group('QR token unit tests', () {
    test('Test QR token generation', () {
      expect(_order.id, isNotNull);
      expect(_order.tokenIsAvailable, isTrue);
      final token = _order.token;
      expect(token, isNotNull);

      expect(OrderQrCode.decode(token!), equals(_order.id));
    });
    test('order without id generates no token', () {
      expect(_orderNoId.id, isNull);
      expect(_orderNoId.tokenIsAvailable, isFalse);
      expect(_orderNoId.token, isNull);
    });
  });

  group('QR code widget tests', () {
    final orderCubit = MockOrderCubit();
    GetIt.I.registerSingleton<OrderCubit>(orderCubit);

    final sc = StreamController<List<Order>>.broadcast();
    when(orderCubit.stream).thenAnswer((_) => sc.stream);

    testWidgets('decode QR code data yields correct orderId', (
      WidgetTester tester,
    ) async {
      expect(_order.tokenIsAvailable, isTrue);
      when(orderCubit.state).thenReturn([_order]);

      // start the app in the test environment
      await tester.pumpWidget(const MaterialApp(home: MyOrdersScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.qr_code));
      await tester.pumpAndSettle();

      expect(find.byType(QrPopup), findsOneWidget);
      expect(find.byType(QrCodeDisplay), findsOneWidget);

      final qrWidget =
          find.byType(QrCodeDisplay).evaluate().single.widget as QrCodeDisplay;
      expect(OrderQrCode.decode(qrWidget.data), equals(_order.id));
    });

    testWidgets('Requesting QR Code from ', (
      WidgetTester tester,
    ) async {
      expect(_orderNoId.tokenIsAvailable, isFalse);
      when(orderCubit.state).thenReturn([_orderNoId]);

      // start the app in the test environment
      await tester.pumpWidget(const MaterialApp(home: MyOrdersScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.qr_code));
      await tester.pumpAndSettle();

      expect(find.byType(QrPopup), findsNothing);
      expect(find.byType(QrCodeDisplay), findsNothing);

      expect(find.textContaining('No code available'), findsOneWidget);
    });
  });
}
