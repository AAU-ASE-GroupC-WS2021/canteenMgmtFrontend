import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth.dart';
import '../../widgets/about_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, this.redirectToNamed = '/'}) : super(key: key);

  /// Redirect after login
  ///
  /// Useful when reloading the page (or from bookmark)
  final String redirectToNamed;

  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
          actions: const [AboutButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 350.0,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: usernameController,
                      validator: (value) => validateUsername(value),
                      autofillHints: const [AutofillHints.username],
                    ),
                    const SizedBox(height: 20), // space between buttons
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) => validatePassword(value),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20), // space between buttons
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        context
                            .read<AuthCubit>()
                            .login(
                              usernameController.text,
                              passwordController.text,
                              awaitRefresh: widget.redirectToNamed != '/',
                            )
                            .then((value) => value == null
                                ? context.beamToNamed(
                                    widget.redirectToNamed,
                                  )
                                : showAlertDialog(value))
                            .onError((error, stackTrace) => showAlertDialog(
                                  "Unknown error occurred while trying to log you in."
                                  "\nPlease refresh the page and try again.!",
                                ));
                      },
                      child: const Text('Log in'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(String error) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Close"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Could not log in"),
      content: Text(error),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password field cannot be empty.';
    } else if (password.length < 9) {
      return 'Password has to be at least 9 characters long.';
    } else if (password.length > 64) {
      return 'Password cannot be longer than 64 characters.';
    }

    return null;
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username field cannot be empty.';
    } else if (username.length < 3) {
      return 'Username has to be at least 3 characters long.';
    } else if (username.length > 24) {
      return 'Username cannot be longer than 24 characters.';
    }

    return null;
  }
}
