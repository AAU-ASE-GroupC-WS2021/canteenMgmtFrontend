import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/order.dart';
import '../services/order_service.dart';

class SingleOrderCubit extends Cubit<OrderState> {
  final OrderService _orderService;
  int? orderId;

  SingleOrderCubit()
      : _orderService = GetIt.I.get<OrderService>(),
        super(OrderState(isLoading: true)) {
    // only refresh if the orderId is set
    if (orderId != null) {
      refresh();
    }
  }

  Future<void> refresh() async {
    if (orderId == null) {
      emit(OrderState(exception: Exception('OrderId not set')));
    } else {
      try {
        emit(OrderState(order: await _orderService.getOrderById(orderId!)));
      } catch (e) {
        emit(OrderState(exception: e));
      }
    }
  }

  setOrderId(int? orderId) {
    this.orderId = orderId;
  }
}

class OrderState {
  final Order? order;
  final Object? exception;
  final bool isLoading;

  OrderState({this.order, this.exception, this.isLoading = false});
}
