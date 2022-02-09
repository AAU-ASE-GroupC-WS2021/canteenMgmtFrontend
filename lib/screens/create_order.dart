import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/models/create_order_menu.dart';
import 'package:canteen_mgmt_frontend/widgets/menu_table_for_ordering.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../cubits/dish_cubit.dart';
import '../cubits/menu_cubit.dart';
import '../models/create_order.dart';
import '../models/create_order_dish.dart';
import '../models/dish.dart';
import '../models/menu.dart';
import '../models/order_dish.dart';
import '../models/order_menu.dart';
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
  final DishCubit dishCubit = GetIt.I<DishCubit>();
  final MenuCubit menuCubit = GetIt.I<MenuCubit>();
  late DateTime selectedPickuptime;

  List<OrderDish> selectedDishes = [];
  List<OrderMenu> selectedMenues = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    selectedPickuptime = DateTime.now().add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            getTimePickerWidget(context),
            const SizedBox(height: 10),
            const Text(
              "Dishes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            DishTableForOrder(addOrderCallback: addDish),
            const SizedBox(height: 20),
            const Text(
              "Menus",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            MenuTableForOrder(addOrderCallback: addMenu),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: 1000,
              child: ListView(
                controller: ScrollController(
                  initialScrollOffset: 0.0,
                  keepScrollOffset: true,
                  debugLabel: 'selected_menues_scroller',
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
                            'TYPE',
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
                          Column(children: const [Text('DISH')]),
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
                      for (var menu in selectedMenues)
                        TableRow(children: [
                          Column(children: const [Text('MENU')]),
                          Column(children: [Text(menu.name)]),
                          Column(children: [Text(menu.price.toString())]),
                          Column(children: [
                            Text(
                              menu.count.toString(),
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
                                      changeMenuCount(menu, false);
                                    },
                                  ),
                                  const Text(' | '),
                                  TextButton(
                                    child: const Text('+'),
                                    onPressed: () {
                                      changeMenuCount(menu, true);
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
            const SizedBox(height: 10),
            Text(
              'Total: ' + total.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            getSubmitWidget(context),
          ],
        ),
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

  void addMenu(Menu menu) {
    int menuIndex = selectedMenues.indexWhere((it) => it.id == menu.id);
    if (menuIndex >= 0 && menuIndex < selectedMenues.length) {
      // if the dish already exists, we add one more to the count
      selectedMenues[menuIndex].count++;
    } else {
      // if the dish does not exist we add it to the order
      selectedMenues.add(
        OrderMenu(
          id: menu.id,
          name: menu.name,
          price: menu.price,
          count: 1,
        ),
      );
    }
    setState(() {
      total += menu.price;
    });
  }

  void changeMenuCount(OrderMenu menu, bool increase) {
    int menuIndex = selectedMenues.indexOf(menu);
    if (increase) {
      selectedMenues[selectedMenues.indexOf(menu)].count++;
      total += menu.price;
    } else {
      selectedMenues[menuIndex].count--;
      if (selectedMenues[menuIndex].count <= 0) {
        selectedMenues.removeAt(menuIndex);
      }
      total -= menu.price;
    }
    setState(() {
      total;
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
    if (selectedDishes.isEmpty && selectedMenues.isEmpty) {
      throw Exception('Nothing ordered selected!');
    } else {
      for (var dish in selectedDishes) {
        dishList.add(CreateOrderDish(id: dish.id, count: dish.count));
      }
      List<CreateOrderMenu> menuList = [];
      for (var menu in selectedMenues) {
        menuList.add(CreateOrderMenu(id: menu.id, count: menu.count));
      }
      return CreateOrder(
        canteenId: widget.canteenId,
        dishes: dishList,
        menus: menuList,
        pickupDate: selectedPickuptime,
        reserveTable: false,
      );
    }
  }

  Map<int, String> dayMapping = {
    DateTime.monday: "MONDAY",
    DateTime.tuesday: "TUESDAY",
    DateTime.wednesday: "WEDNESDAY",
    DateTime.thursday: "THURSDAY",
    DateTime.friday: "FRIDAY",
  };

  updatePickupTime(DateTime newPickupTime) {
    if (selectedPickuptime.weekday != newPickupTime.weekday) {
      dishCubit.dishDay = dayMapping[newPickupTime.weekday];
      dishCubit.refresh();
      menuCubit.refresh(dayMapping[newPickupTime.weekday]);
    }
    setState(() {
      selectedPickuptime = newPickupTime;
    });
  }

  getTimePickerWidget(BuildContext context) {
    return selectedDishes.isEmpty && selectedMenues.isEmpty
        ? OrderSelectPickupTimeWidget(pickuptimeCallback: updatePickupTime)
        : const Text(
            'No Dish/ Menu may be selected when changing the time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
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
      return selectedDishes.isEmpty && selectedMenues.isEmpty
          ? const Text(
              'At least 1 Dish or Menu must be selected',
              style: warningStyle,
            )
          : FloatingActionButton(
              child: const Icon(Icons.add_chart_rounded),
              onPressed: () {
                final orderReturn = orderService.createOrder(prepareSubmit());
                orderReturn.then((data) {
                  context.popToNamed('/order/${data.id}');
                });
              },
            );
    }
  }
}
