import 'dart:developer';

import 'package:canteen_mgmt_frontend/cubits/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/menu.dart';
import '../services/menu_service.dart';
import '../widgets/menus/create_menu_from.dart';
import '../widgets/menus/delete_menu_from.dart';
import '../widgets/menus/menu_table.dart';
import '../widgets/menus/update_menu_from.dart';

class MenuMgmtScreen extends StatefulWidget {
  const MenuMgmtScreen({Key? key}) : super(key: key);

  @override
  State<MenuMgmtScreen> createState() => _MenuMgmtScreenState();
}

class _MenuMgmtScreenState extends State<MenuMgmtScreen> {
  final MenuService menuService = MenuService();
  late Future<List<Menu>> futureMenus;

  @override
  void initState() {
    super.initState();
    futureMenus = menuService.fetchMenus();
  }

  void _myfunc([String dishDay = "MONDAY"]) {
    final newDishes = menuService.fetchMenus(menuDay: dishDay);
    setState(() {
      futureMenus = newDishes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _getButtons(context, menuService),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Menu>>(
              future: futureMenus,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: SingleChildScrollView(
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
                            onSelected: (value) {
                              _myfunc(value.toString());
                              log("value:$value");
                            },
                          ),
                          MenuTable(menus: snapshot.data!),
                        ],
                      ),
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

//ignore:long-method
List<Widget> _getButtons(BuildContext context, MenuService menuService) {
  return [
    ElevatedButton(
      child: const Text('Create Menu'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Create Menu'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateMenuForm(
                  (menu) => {
                    menuService
                        .createMenu(menu)
                        .then((value) => {
                              log(value.toString()),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value.toString()),
                                ),
                              ),
                              Navigator.pop(context),
                              GetIt.I.get<MenuCubit>().refresh(),
                            })
                        .onError(
                          (error, stackTrace) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
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
    ),
    const SizedBox(width: 20),
    ElevatedButton(
      child: const Text('Update Menu'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Update Menu'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpdateMenuForm(
                  (menu) => {
                    menuService
                        .updateMenu(menu)
                        .then((value) => {
                              log(value.toString()),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value.toString()),
                                ),
                              ),
                              Navigator.pop(context),
                              GetIt.I.get<MenuCubit>().refresh(),
                            })
                        .onError(
                          (error, stackTrace) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
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
    ),
    const SizedBox(width: 20),
    ElevatedButton(
      child: const Text('Delete Menu'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Delete Menu'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DeleteMenuForm(
                  (menu) => {
                    menuService.deleteMenu(menu).then((value) => {
                          log(value.toString()),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value.toString()),
                            ),
                          ),
                          Navigator.pop(context),
                          GetIt.I.get<MenuCubit>().refresh(),
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
