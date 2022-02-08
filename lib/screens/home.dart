import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth.dart';
import '../widgets/about_button.dart';
import '../widgets/signin_button.dart';
import '../widgets/signout_button.dart';
import '../widgets/signup_button.dart';
import '../widgets/text_heading.dart';
import '../widgets/user_info_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.beamToNamed('/menu'),
              child: const Text('Menus'),
            ),
            const SizedBox(height: 20), // space between buttons
            // ElevatedButton(
            //   onPressed: () => context.beamToNamed('/dish'),
            //   child: const Text('Dish Service Demo'),
            // ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () => context.beamToNamed('/qr-demo'),
              child: const Text('QR Scanner Demo'),
            ),
          ],
        ),
      ),
    );
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
              offstage: ((state.type == 'USER') | (state.type =='GUEST')),
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
