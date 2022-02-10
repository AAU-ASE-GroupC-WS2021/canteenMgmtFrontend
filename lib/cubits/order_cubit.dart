import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/orders/order.dart';
import '../services/order_service.dart';

class OrderCubit extends Cubit<List<Order>> {
  final OrderService _orderService;

  OrderCubit()
      : _orderService = GetIt.I.get<OrderService>(),
        super([]) {
    refresh();
  }

  Future<void> refresh() async => emit(await _orderService.getOrders());
}
