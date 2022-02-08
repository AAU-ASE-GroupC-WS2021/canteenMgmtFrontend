import 'dart:developer';

import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth.dart';
import '../models/menu.dart';
import '../services/menu_service.dart';
import '../widgets/create_menu_from.dart';
import '../widgets/delete_menu_from.dart';
import '../widgets/menu_table.dart';
import '../widgets/text_heading.dart';
import '../widgets/update_menu_from.dart';

class MenuDemoScreen extends StatefulWidget {
  const MenuDemoScreen({Key? key}) : super(key: key);

  @override
  State<MenuDemoScreen> createState() => _MenuDemoScreenState();
}

class _MenuDemoScreenState extends State<MenuDemoScreen> {
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
      drawer: const MenuManagement(),
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

class MenuManagement extends StatelessWidget {
  const MenuManagement({Key? key}) : super(key: key);

  get menuService => MenuService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    TextHeading(
                      'Menu Management',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              onTap: () {
                context.beamToNamed("/");
              },
            ),
            ListTile(
              title: const Text('Create Menu'),
              leading: const Icon(
                Icons.my_library_add,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
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
            ListTile(
              title: const Text('Update Menu'),
              leading: const Icon(
                Icons.update,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
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
            ListTile(
              title: const Text('Delete Menu'),
              leading: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
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
                                }),
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
