import 'dart:developer';

import 'package:beamer/beamer.dart';
import '../widgets/text_heading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/user_info_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../cubits/auth.dart';
import '../widgets/about_button.dart';
import '../widgets/signin_button.dart';
import '../widgets/signout_button.dart';
import '../widgets/signup_button.dart';
import '../models/dish.dart';
import '../services/dish_service.dart';
import '../widgets/create_dish_from.dart';
import '../widgets/delete_dish_from.dart';
import '../widgets/dish_table.dart';
import '../widgets/update_dish_from.dart';

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
        title: const Text('Dish Service Demo'),
        actions: const [
          SignInButton(),
          UserInfoButton(),
          SignOutButton(),
          SignUpButton(),
          AboutButton(),
        ],
      ),
      drawer: const DishManagement(),
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

class DishManagement extends StatelessWidget {
  const DishManagement({Key? key}) : super(key: key);

  get dishService => DishService();

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
                      'Dish Management',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: ((state.type == 'USER') | (state.type == 'GUEST')),
              child: ListTile(
                title: const Text('Home'),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onTap: () {
                  context.beamToNamed("/");
                },
              ),
            ),
            Offstage(
              offstage: ((state.type == 'USER') | (state.type == 'GUEST')),
              child: ListTile(
                title: const Text('Create Dish'),
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
                        title: const Text('Create Dish'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CreateDishForm(
                            (dish) => {
                              dishService
                                  .createDish(dish)
                                  .then((value) async => {
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
            ),
            Offstage(
              offstage: ((state.type == 'USER') | (state.type == 'GUEST')),
              child: ListTile(
                title: const Text('Update Dish'),
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
                        title: const Text('Update Dish'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UpdateDishForm(
                            (dish) => {
                              dishService
                                  .updateDish(dish)
                                  .then((value) async => {
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
                                    (error) => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
            ),
            Offstage(
              offstage: ((state.type == 'USER') | (state.type == 'GUEST')),
              child: ListTile(
                title: const Text('Delete Dish'),
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
                        title: const Text('Delete Dish'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DeleteDishForm(
                            (dish) => {
                              dishService
                                  .deleteDish(dish)
                                  .then((value) async => {
                                        log(value.toString()),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
            ),
            Offstage(
              offstage: !state.authenticated,
              child: ListTile(
                title: const Text('Log out'),
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onTap: () async {
                  context.read<AuthCubit>().logout();
                  context.beamToNamed('/');
                },
              ),
            ),
            Offstage(
              offstage: state.authenticated,
              child: ListTile(
                title: const Text('Log in'),
                leading: const Icon(
                  Icons.login,
                  color: Colors.black,
                ),
                onTap: () async {
                  context.beamToNamed('/signin');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
