import 'package:beamer/beamer.dart';
import '../cubits/menu_cubit.dart';
import '../util/day_mapping.dart';
import '../widgets/menus/menu_table_for_ordering.dart';
import '../widgets/prev_next_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../cubits/auth.dart';
import '../widgets/about_button.dart';
import '../widgets/users/signin_button.dart';
import '../widgets/users/signout_button.dart';
import '../widgets/users/signup_button.dart';
import '../widgets/text_heading.dart';
import '../widgets/users/user_info_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _headingText;
  late DateTime _selectedDateTime;
  final MenuCubit menuCubit = GetIt.I.get<MenuCubit>();

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _updateHeadingText();
    menuCubit.menuDay = getDayName(_selectedDateTime.weekday);
    menuCubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Management'),
        actions: const [
          SignInButton(),
          UserInfoButton(),
          SignOutButton(),
          SignUpButton(),
          AboutButton(),
        ],
      ),
      drawer: const HomeMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              PrevNextText(_headingText, callback: updateMenuDate),
              const SizedBox(
                height: 30,
              ),
              MenuTableForOrder(
                addOrderCallback: (_) => {},
                showAdd: false,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text('Place Order'),
                onPressed: () {
                  context.beamToNamed('/order-select-canteen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateMenuDate(Direction dir) {
    setState(() {
      do {
        _selectedDateTime = dir == Direction.next
            ? _selectedDateTime.add(const Duration(days: 1))
            : _selectedDateTime.subtract(const Duration(days: 1));
      } while ({6, 7}.contains(_selectedDateTime.weekday));
    });
    _updateHeadingText();
    menuCubit.menuDay = getDayName(_selectedDateTime.weekday);
    menuCubit.refresh();
  }

  void _updateHeadingText() {
    setState(() {
      _headingText =
          'Menu for ${DateFormat('EEEE, d. LLL y').format(_selectedDateTime)}';
    });
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

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
                      'Canteen Management',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: state.type != 'OWNER',
              child: ListTile(
                title: const Text('Admin Dashboard'),
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.black,
                ),
                onTap: () => context.beamToNamed('/admin'),
              ),
            ),
            Offstage(
              offstage: !{'ADMIN', 'OWNER'}.contains(state.type),
              child: ListTile(
                title: const Text('Menu Management'),
                leading: const Icon(
                  Icons.menu_book,
                  color: Colors.black,
                ),
                onTap: () => context.beamToNamed('/menu'),
              ),
            ),
            Offstage(
              offstage: !{'ADMIN', 'OWNER'}.contains(state.type),
              child: ListTile(
                title: const Text('Dish Management'),
                leading: const Icon(
                  Icons.local_restaurant,
                  color: Colors.black,
                ),
                onTap: () => context.beamToNamed('/dish'),
              ),
            ),
            Offstage(
              offstage: !{'ADMIN', 'OWNER'}.contains(state.type),
              child: ListTile(
                title: const Text('Scan Order'),
                leading: const Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
                onTap: () => context.beamToNamed('/scan-order'),
              ),
            ),
            Offstage(
              offstage: !state.authenticated,
              child: ListTile(
                title: const Text('Your Orders'),
                leading: const Icon(
                  Icons.featured_play_list_outlined,
                  color: Colors.black,
                ),
                onTap: () => context.beamToNamed('/order'),
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
