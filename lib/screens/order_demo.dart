import 'package:canteen_mgmt_frontend/models/create_order.dart';
import 'package:canteen_mgmt_frontend/models/create_order_dish.dart';
import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../models/order_dish.dart';
import '../services/dish_service.dart';
import '../services/order_service.dart';

class OrderDemoScreen extends StatefulWidget {
  const OrderDemoScreen({Key? key}) : super(key: key);

  @override
  State<OrderDemoScreen> createState() => _OrderDemoScreenState();
}

class _OrderDemoScreenState extends State<OrderDemoScreen> {
  final DishService dishService = DishService();
  final OrderService orderService = OrderService();
  late Future<List<Dish>> currentDishes;

  List<OrderDish> selectedDishes = [];

  @override
  void initState() {
    super.initState();
    currentDishes = dishService.fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                final newDishes = dishService.fetchDishes();
                setState(() {
                  currentDishes = newDishes;
                });
              },
              child: const Text('Refresh'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Dish>>(
              future: currentDishes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Table(
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
                            'Type',
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
                            'Add to order',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ]),
                      for (var dish in snapshot.data!)
                        TableRow(children: [
                          Column(children: [Text(dish.id.toString())]),
                          Column(children: [Text(dish.name)]),
                          Column(children: [Text(dish.type)]),
                          Column(children: [Text(dish.price.toString())]),
                          Column(children: [
                            TextButton(
                              child: const Text('+'),
                              onPressed: () {
                                addDish(dish);
                              },
                            ),
                          ]),
                        ]),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                }
              },
            ),
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
                        'Type',
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
                        'Decrease Count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Column(children: const [
                      Text(
                        'Increase Count',
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
                      Column(children: [Text(dish.type)]),
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
                      Column(children: [
                        TextButton(
                          child: const Text('-'),
                          onPressed: () {
                            decreaseCount(dish);
                          },
                        ),
                      ]),
                      Column(children: [
                        TextButton(
                          child: const Text('+'),
                          onPressed: () {
                            increaseCount(dish);
                          },
                        ),
                      ]),
                    ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final orderReturn = orderService.createOrder(prepareSubmit());
                print(orderReturn);
                // TODO: REDIRECT TO ORDER DISPLAY
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
      selectedDishes.add(OrderDish(
          id: dish.id,
          name: dish.name,
          price: dish.price,
          type: dish.type,
          count: 1));
    }

    setState(() {});
  }

  void decreaseCount(OrderDish dish) {
    int dishIndex = selectedDishes.indexOf(dish);
    selectedDishes[dishIndex].count--;
    if (selectedDishes[dishIndex].count <= 0) {
      selectedDishes.removeAt(dishIndex);
    }
    setState(() {});
  }

  void increaseCount(OrderDish dish) {
    selectedDishes[selectedDishes.indexOf(dish)].count++;
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
      return CreateOrder(userId: 1, canteenId: 1, dishes: dishList);
    }
  }
}
