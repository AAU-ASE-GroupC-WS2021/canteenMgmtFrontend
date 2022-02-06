import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/cubits/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Offstage(
        offstage: !state.authenticated,
        child: ElevatedButton(
          child: const Text("Log out"),
          onPressed: () async {
            context.read<AuthCubit>().logout();
            context.beamToNamed('/');
          },
        ),
      ),
    );
  }
}
