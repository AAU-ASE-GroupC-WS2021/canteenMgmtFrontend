import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/dish.dart';
import '../services/dish_service.dart';
import '../widgets/dishes/create_dish_from.dart';
import '../widgets/dishes/delete_dish_from.dart';
import '../widgets/dishes/dish_table.dart';
import '../widgets/dishes/update_dish_from.dart';

class DishMgmtScreen extends StatefulWidget {
  const DishMgmtScreen({Key? key}) : super(key: key);

  @override
  State<DishMgmtScreen> createState() => _DishMgmtScreenState();
}

class _DishMgmtScreenState extends State<DishMgmtScreen> {
  final DishService dishService = GetIt.I<DishService>();
  late Future<List<Dish>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = dishService.fetchDishes();
  }

  void refreshState() {
    final newDishes = dishService.fetchDishes();
    setState(() {
      futureDishes = newDishes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newDishes = dishService.fetchDishes();
                setState(() {
                  futureDishes = newDishes;
                });
              },
              child: const Text('Refresh'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _getButtons(context, dishService),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Dish>>(
              future: futureDishes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: DishTable(dishes: snapshot.data!),
                    ),
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
          ],
        ),
      ),
    );
  }
}

List<Widget> _getButtons(BuildContext context, DishService dishService) {
  return [
    ElevatedButton(
      child: const Text('Create Dish'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Create Dish'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateDishForm(
                  (Dish dish) {
                    dishService.createDish(dish).then((value) {
                      log(value.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value.toString()),
                        ),
                      );
                      Navigator.pop(context);
                    }).onError(
                      (error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    const SizedBox(width: 20),
    ElevatedButton(
      child: const Text('Update Dish'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Update Dish'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpdateDishForm(
                  (dish) => {
                    dishService.updateDish(dish).then((value) async => {
                          log(value.toString()),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value.toString()),
                            ),
                          ),
                          Navigator.pop(context),
                        }),
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    const SizedBox(width: 20),
    ElevatedButton(
      child: const Text('Delete Dish'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Delete Dish'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DeleteDishForm(
                  (dish) => {
                    dishService.deleteDish(dish).then((value) async => {
                          log(value.toString()),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value.toString()),
                            ),
                          ),
                          Navigator.pop(context),
                        }),
                  },
                ),
              ),
            );
          },
        );
      },
    ),
  ];
}
