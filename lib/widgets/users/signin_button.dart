import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Offstage(
        offstage: state.authenticated,
        child: ElevatedButton(
          child: const Text("Log in"),
          onPressed: () => context.beamToNamed('/signin'),
        ),
      ),
    );
  }
}
