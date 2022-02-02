class OrderArguments {
  final int canteenId;
  final DateTime pickupDate;
  final bool reserveTable;

  OrderArguments({
    required this.canteenId,
    required this.pickupDate,
    required this.reserveTable,
  });

  bool isValid() {
    if (canteenId < 1) {
      return false;
    }
    if (pickupDate.isBefore(DateTime.now().add(const Duration(hours: 1)))) {
      return false;
    }
    return true;
  }
}
