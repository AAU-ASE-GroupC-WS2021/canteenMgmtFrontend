import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/create_order.dart';
import '../models/create_order_dish.dart';
import '../models/dish.dart';
import '../models/order_dish.dart';
import '../services/order_service.dart';
import '../widgets/dish_table_for_ordering.dart';
import '../widgets/order_select_pickup_time.dart';

class CreateOrderScreen extends StatefulWidget {
  final int canteenId;

  const CreateOrderScreen({Key? key, required this.canteenId})
      : super(key: key);

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final OrderService orderService = GetIt.I<OrderService>();
  late DateTime selectedPickuptime;

  List<OrderDish> selectedDishes = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    selectedPickuptime = DateTime.now().add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            OrderSelectPickupTimeWidget(pickuptimeCallback: updatePickupTime),
            const SizedBox(height: 20),
            DishTableForOrder(addOrderCallback: addDish),
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: 1000,
              child: ListView(
                controller: ScrollController(
                  initialScrollOffset: 0.0,
                  keepScrollOffset: true,
                  debugLabel: 'selected_dishes_scroller',
                ),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Table(
                    defaultColumnWidth: const FixedColumnWidth(150.0),
                    border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                    children: [
                      TableRow(children: [
                        Column(children: const [
                          Text(
                            'ID',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Column(children: const [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Column(children: const [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Column(children: const [
                          Text(
                            'Count',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Column(children: const [
                          Text(
                            'Change Count',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ]),
                      for (var dish in selectedDishes)
                        TableRow(children: [
                          Column(children: [Text(dish.id.toString())]),
                          Column(children: [Text(dish.name)]),
                          Column(children: [Text(dish.price.toString())]),
                          Column(children: [
                            Text(
                              dish.count.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                          Column(
                            children: [
                              Row(
                                children: [
                                  TextButton(
                                    child: const Text('-'),
                                    onPressed: () {
                                      changeCount(dish, false);
                                    },
                                  ),
                                  const Text(' | '),
                                  TextButton(
                                    child: const Text('+'),
                                    onPressed: () {
                                      changeCount(dish, true);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: ' + total.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            getSubmitWidget(context),
          ],
        ),
      ),
    );
  }

  void addDish(Dish dish) {
    int dishIndex = selectedDishes.indexWhere((it) => it.id == dish.id);
    if (dishIndex >= 0 && dishIndex < selectedDishes.length) {
      // if the dish already exists, we add one more to the count
      selectedDishes[dishIndex].count++;
    } else {
      // if the dish does not exist we add it to the order
      selectedDishes.add(
        OrderDish(
          id: dish.id,
          name: dish.name,
          price: dish.price,
          count: 1,
        ),
      );
    }
    setState(() {
      total += dish.price;
    });
  }

  void changeCount(OrderDish dish, bool increase) {
    int dishIndex = selectedDishes.indexOf(dish);
    if (increase) {
      selectedDishes[selectedDishes.indexOf(dish)].count++;
      total += dish.price;
    } else {
      selectedDishes[dishIndex].count--;
      if (selectedDishes[dishIndex].count <= 0) {
        selectedDishes.removeAt(dishIndex);
      }
      total -= dish.price;
    }
    setState(() {
      total;
    });
  }

  CreateOrder prepareSubmit() {
    List<CreateOrderDish> dishList = [];
    if (selectedDishes.isEmpty) {
      throw Exception('No Dishes selected!');
    } else {
      for (var dish in selectedDishes) {
        dishList.add(CreateOrderDish(id: dish.id, count: dish.count));
      }
      return CreateOrder(
        canteenId: widget.canteenId,
        dishes: dishList,
        pickupDate: selectedPickuptime,
        reserveTable: false,
      );
    }
  }

  updatePickupTime(DateTime newPickupTime) {
    setState(() {
      selectedPickuptime = newPickupTime;
    });
  }

  getSubmitWidget(BuildContext context) {
    const TextStyle warningStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );
    if (selectedPickuptime
        .isBefore(DateTime.now().add(const Duration(hours: 1)))) {
      return const Text(
        'Pickup must be at least 1 hour from now!',
        style: warningStyle,
      );
    } else if (selectedPickuptime.hour < 9 || selectedPickuptime.hour > 16) {
      return const Text(
        'Canteens are only open between 09:00 and 17:00',
        style: warningStyle,
      );
    } else {
      return selectedDishes.isEmpty
          ? const Text('At least 1 Dish must be selected', style: warningStyle)
          : FloatingActionButton(
              child: const Icon(Icons.add_chart_rounded),
              onPressed: () {
                final orderReturn = orderService.createOrder(prepareSubmit());
                orderReturn.then((data) {
                  context.beamToNamed('/order/${data.id}', beamBackOnPop: true);
                });
              },
            );
    }
  }
}
