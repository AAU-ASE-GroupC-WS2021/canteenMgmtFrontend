import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/order.dart';
import '../services/order_service.dart';

class SingleOrderCubit extends Cubit<OrderState> {
  final OrderService _orderService;

  SingleOrderCubit()
      : _orderService = GetIt.I.get<OrderService>(),
        super(OrderState(isLoading: true));

  Future<void> refresh(int orderId) async {
    try {
      emit(OrderState(order: await _orderService.getOrderById(orderId)));
    } catch (e) {
      emit(OrderState(exception: e));
    }
  }
}

class OrderState {
  final Order? order;
  final Object? exception;
  final bool isLoading;

  OrderState({this.order, this.exception, this.isLoading = false});

  getOrderDishes() {
    return order == null ? [] : order?.dishes.entries;
  }
}
