import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/dish.dart';
import '../services/dish_service.dart';
import '../widgets/dish_table.dart';
import '../widgets/delete_dish_from.dart';
import '../widgets/update_dish_from.dart';
import '../widgets/create_dish_from.dart';

class DishDemoScreen extends StatefulWidget {
  const DishDemoScreen({Key? key}) : super(key: key);

  @override
  State<DishDemoScreen> createState() => _DishDemoScreenState();
}

class _DishDemoScreenState extends State<DishDemoScreen> {
  final DishService dishService = GetIt.I<DishService>();
  late Future<List<Dish>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = dishService.fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dish Service Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(
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
                          (dish) => {
                            GetIt.I
                                .get<DishService>()
                                .createDish(dish)
                                .then((value) => {Navigator.pop(context)})
                                .onError(
                                  (error, stackTrace) => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    ),
                                  },
                                ),
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Create Dish'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text("Update Dish"),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpdateDishForm(
                          (dish) => {
                            GetIt.I
                                .get<DishService>()
                                .updateDish(dish)
                                .then((value) => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(value.toString()),
                                        ),
                                      ),
                                      Navigator.pop(context),
                                    })
                                .onError(
                                  (error, stackTrace) => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    ),
                                  },
                                ),
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text("Update Dish"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text("Delete Dish"),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteDishForm(
                          (dish) => {
                            GetIt.I
                                .get<DishService>()
                                .deleteDish(dish)
                                .then((value) async => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(value.toString()),
                                        ),
                                      ),
                                      Navigator.pop(context),
                                    })
                                .onError(
                                  (error, stackTrace) => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    ),
                                  },
                                ),
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text("Delete Dish"),
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
