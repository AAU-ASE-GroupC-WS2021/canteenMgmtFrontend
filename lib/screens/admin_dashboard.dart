import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubits/canteens_cubit.dart';
import '../cubits/filtered_users_cubit.dart';
import '../models/canteen.dart';
import '../models/user.dart';
import '../services/canteen_service.dart';
import '../services/owner_user_service.dart';
import '../widgets/canteen_listview.dart';
import '../widgets/create_canteen_button.dart';
import '../widgets/create_user_button.dart';
import '../widgets/text_heading.dart';
import '../widgets/user_listview.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final CanteenService canteenService = GetIt.I<CanteenService>();
  final OwnerUserService userService = GetIt.I<OwnerUserService>();
  final CanteensCubit canteensCubit = GetIt.I.get<CanteensCubit>();
  final FilteredUsersCubit usersCubit = GetIt.I.get<FilteredUsersCubit>();

  Canteen? _selectedCanteen;

  @override
  void initState() {
    super.initState();
    usersCubit.setCanteenIDFilter(null);
    usersCubit.setTypeFilter(UserType.ADMIN);
    usersCubit.refresh();
    canteensCubit.refresh();
  }

  void showAdmins(Canteen? c) {
    try {
      setState(() {
        _selectedCanteen = c;
      });
      usersCubit.setCanteenIDFilter(c?.id);
      usersCubit.setTypeFilter(UserType.ADMIN);
      usersCubit.refresh();
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
                            children: const <Widget>[
                              CreateCanteenButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<CanteensCubit, CanteensState>(
                      bloc: GetIt.I.get<CanteensCubit>(),
                      builder: (context, state) => state.exception != null
                          ? Center(
                              child: Text('${state.exception}'),
                            )
                          : state.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: CanteenListview(
                                    showAdmins,
                                    canteens: state.canteens!,
                                  ),
                                ),
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
                          TextHeading(_selectedCanteen != null
                              ? 'Staff [filtered]'
                              : 'Staff [all]'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CreateUserButton(
                                defaultCanteen: _selectedCanteen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<FilteredUsersCubit, FilteredUsersState>(
                      bloc: GetIt.I.get<FilteredUsersCubit>(),
                      builder: (context, state) => state.exception != null
                          ? Center(
                              child: Text('${state.exception}'),
                            )
                          : state.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: UserListview(
                                    users: state.users!,
                                  ),
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
