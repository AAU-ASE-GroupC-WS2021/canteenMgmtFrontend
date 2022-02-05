import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/create_order.dart';
import '../models/create_order_dish.dart';
import '../models/dish.dart';
import '../models/order_arguments.dart';
import '../models/order_dish.dart';
import '../services/order_data_helper_service.dart';
import '../services/order_service.dart';
import '../widgets/dish_table_for_ordering.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderService orderService = GetIt.I<OrderService>();
  final OrderDataHelperService orderDataHelperService =
      GetIt.I<OrderDataHelperService>();

  List<OrderDish> selectedDishes = [];
  late OrderArguments orderArguments;
  double total = 0;

  @override
  void initState() {
    super.initState();
    orderArguments = orderDataHelperService.getOrderArguments();
    if (!orderArguments.isValid()) {
      Future(() {
        context.beamToNamed('/order-select-canteen', beamBackOnPop: true);
      });
    }
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
            DishTableForOrder(addOrderCallback: addDish),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Table(
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
            ElevatedButton(
              onPressed: () {
                final orderReturn = orderService.createOrder(prepareSubmit());
                orderReturn.then((data) {
                  orderDataHelperService.setOrderArguments(
                    -1,
                    DateTime.now(),
                    false,
                  );
                  context.beamToNamed('/order/${data.id}', beamBackOnPop: true);
                });
              },
              child: const Text('Submit order'),
            ),
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
    total += dish.price;
    setState(() {});
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
    setState(() {});
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
        userId: 1,
        canteenId: orderArguments.canteenId,
        dishes: dishList,
        pickupDate: orderArguments.pickupDate,
        reserveTable: orderArguments.reserveTable,
      );
    }
  }
}
