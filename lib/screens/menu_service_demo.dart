import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../services/menu_service.dart';
import '../widgets/menu_table.dart';

class MenuDemoScreen extends StatefulWidget {
  const MenuDemoScreen({Key? key}) : super(key: key);

  @override
  State<MenuDemoScreen> createState() => _MenuDemoScreenState();
}

class _MenuDemoScreenState extends State<MenuDemoScreen> {
  final MenuService menuService = MenuService();
  late Future<List<Dish>> futureMenus;

  @override
  void initState() {
    super.initState();
    futureMenus = menuService.fetchMenus();
  }

  void _myfunc([String dishDay="MONDAY"]){
    final newDishes = menuService.fetchMenus(dishDay);
    setState(() {
      futureMenus = newDishes;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Service Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PopupMenuButton(
                child: const Text("Filter by Day"),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("MONDAY"),
                    value: "MONDAY",
                  ),
                  const PopupMenuItem(
                    child: Text("TUESDAY"),
                    value: "TUESDAY",
                  ),
                  const PopupMenuItem(
                    child: Text("WEDNESDAY"),
                    value: "WEDNESDAY",
                  ),
                  const PopupMenuItem(
                    child: Text("THURSDAY"),
                    value: "THURSDAY",
                  ),
                  const PopupMenuItem(
                    child: Text("FRIDAY"),
                    value: "FRIDAY",
                  ),
                ],
              onSelected: (value){
                  _myfunc(value.toString());
                  print("value:$value");
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newDishes = menuService.fetchMenus("MONDAY");
                setState(() {
                  futureMenus = newDishes;
                });
              },
              child: const Text('Sort by Monday'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newDishes = menuService.fetchMenus();
                setState(() {
                  futureMenus = newDishes;
                });
              },
              child: const Text('Show all Menu'),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     menuService.createDish();
            //   },
            //   child: const Text('Create Dish'),
            // ),
            // const SizedBox(height: 20),
            FutureBuilder<List<Dish>>(
              future: futureMenus,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: SingleChildScrollView(
                        child: MenuTable(dishes: snapshot.data!),
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
          ],
        ),
      ),
    );
  }
}
