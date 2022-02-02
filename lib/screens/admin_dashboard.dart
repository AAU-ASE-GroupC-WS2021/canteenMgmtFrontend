import '../models/user.dart';
import '../services/owner_user_service.dart';
import '../widgets/user_listview.dart';

import '../widgets/create_user_button.dart';
import 'package:get_it/get_it.dart';

import '../widgets/create_canteen_button.dart';
import '../widgets/text_heading.dart';

import '../widgets/canteen_listview.dart';
import '../models/canteen.dart';
import '../services/canteen_service.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final CanteenService canteenService = GetIt.I<CanteenService>();
  final OwnerUserService userService = GetIt.I<OwnerUserService>();
  late Future<List<Canteen>> futureCanteens;
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureCanteens = canteenService.getCanteens();
    futureUsers = userService.getAllByType(UserType.ADMIN);
  }

  bool createCanteen(Canteen c) {
    try {
      canteenService.createCanteen(c);
      return true;
    } catch (e) {
      showSnackbar(e.toString());
      return false;
    }
  }

  bool createUser(User user) {
    try {
      userService.createUser(user);
      return true;
    } catch (e) {
      showSnackbar(e.toString());
      return false;
    }
  }

  bool editCanteen(Canteen c) {
    try {
      canteenService.updateCanteen(c);
      return true;
    } catch (e) {
      showSnackbar(e.toString());
      return false;
    }
  }

  void showAdmins(Canteen? c) {
    try {
      setState(() {
        futureUsers = c != null ?
          userService.getAllByTypeAndCanteen(UserType.ADMIN, c.id) :
          userService.getAllByType(UserType.ADMIN);
      });
    } catch (e) {
      showSnackbar(e.toString());
    }
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 32.0),
                          const TextHeading('Canteens'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CreateCanteenButton(createCanteen),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: FutureBuilder<List<Canteen>>(
                        future: futureCanteens,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CanteenListview(editCanteen, showAdmins, canteens: snapshot.data!,);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          } else {
                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final newCanteens = canteenService.getCanteens();
                        setState(() {
                          futureCanteens = newCanteens;
                        });
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),



            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 32.0),
                          const TextHeading('Canteen Staff'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CreateUserButton(createUser),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: FutureBuilder<List<User>>(
                        future: futureUsers,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return UserListview(users: snapshot.data!,);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          } else {
                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
