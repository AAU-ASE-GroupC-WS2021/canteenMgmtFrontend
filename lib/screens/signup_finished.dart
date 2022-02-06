import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth.dart';
import '../widgets/about_button.dart';

class SignupFinishedScreen extends StatelessWidget {
  const SignupFinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Create a new profile'),
          actions: const [AboutButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.authenticated)
                const Text(
                  "You are already logged in!",
                  style: TextStyle(fontSize: 25),
                )
              else
                const Text(
                  "Profile created successfully.",
                  style: TextStyle(fontSize: 25),
                ),
              const SizedBox(height: 20), // space between buttons
              ElevatedButton(
                onPressed: () => context.beamToNamed('/'),
                child: const Text('Go to the Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
