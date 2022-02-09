import 'package:canteen_mgmt_frontend/screens/profile_mgmt_screen.dart';

import '../screens/signup_screen.dart';
import '../services/signup_service.dart';
import '../services/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth.dart';

class UserInfoButton extends StatelessWidget {
  const UserInfoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Offstage(
        offstage: !state.authenticated,
        // TODO later: make the button dropdown or popup for more functions.
        child: ElevatedButton(
        child: Text("@${state.username}"),
        onPressed: () => {
          // Do some action: either show a popup or dropdown, or go to the user profile page.
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileManagementScreen())),
        },
        ),
      ),
    );
  }
}
