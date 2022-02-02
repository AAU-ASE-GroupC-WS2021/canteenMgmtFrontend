import '../models/order_arguments.dart';
import 'abstract_service.dart';

class OrderDataHelperService extends AbstractService {
  static OrderArguments orderArguments = OrderArguments(
    canteenId: -1,
    pickupDate: DateTime.now(),
    reserveTable: false,
  );

  OrderArguments getOrderArguments() {
    return orderArguments;
  }

  void setOrderArguments(
    int canteenId,
    DateTime pickupDate,
    bool reserveTable,
  ) {
    orderArguments = OrderArguments(
      canteenId: canteenId,
      pickupDate: pickupDate,
      reserveTable: reserveTable,
    );
  }

  bool isValid() {
    return orderArguments.isValid();
  }
}
