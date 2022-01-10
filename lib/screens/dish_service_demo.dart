import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../services/dish_service.dart';
import '../widgets/dish_table.dart';

class DishDemoPage extends StatefulWidget {
  const DishDemoPage({Key? key}) : super(key: key);

  @override
  State<DishDemoPage> createState() => _DishDemoPageState();
}

class _DishDemoPageState extends State<DishDemoPage> {
  final DishService dishService = DishService();
  late Future<List<Dish>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = dishService.fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dish Service Demo")),
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
              child: const Text("Refresh"),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Dish>>(
              future: futureDishes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DishTable(dishes: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
