import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../services/signup_service.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupService signupService = SignupService();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child:
        Scaffold(
      appBar: AppBar(title: const Text('Create a new profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 300.0,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: usernameController,
                      validator: (value) {
                        return validateUsername(value);
                      },
                    ),
                    const SizedBox(height: 20), // space between buttons
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) {
                        return validatePassword(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20), // space between buttons
                    ElevatedButton(
                      onPressed: () => {
                      if (_formKey.currentState!.validate()) {
                        signupService.createProfile(usernameController.text, passwordController.text)
                            .then((value) => {
                          if (value == null) {
                            context.beamToNamed('/signup-finished'),
                          }
                          else {
                            showAlertDialog(value)
                          },
                        })
                            .onError((error, stackTrace) => {
                          showAlertDialog("Unknown error occurred while trying to create a new profile.\nPlease refresh the page and try again.!"),
                        }),
                      },
                      },
                      child: const Text('Sign up'),
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
      onPressed: () { Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Could not create profile"),
      content: Text(error),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static final regexAtLeastOneUppercaseLetter = RegExp(r'(?=.*[A-Z])');
  static final regexAtLeastOneLowercaseLetter = RegExp(r'(?=.*[a-z])');
  static final regexAtLeastOneDigit = RegExp(r'(?=.*[0-9])');
  static final regexAlphanumericOnly = RegExp(r'^[a-zA-Z0-9]+$');

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password field cannot be empty.';
    }
    else if (password.length < 9) {
      return 'Password has to be at least 9 characters long.';
    }
    else if (password.length > 64) {
      return 'Password cannot be longer than 64 characters.';
    }
    else if (!regexAtLeastOneUppercaseLetter.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter.';
    }
    else if (!regexAtLeastOneLowercaseLetter.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter.';
    }
    else if (!regexAtLeastOneDigit.hasMatch(password)) {
      return 'Password must contain at least one digit.';
    }

    return null;
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username field cannot be empty.';
    }
    else if (username.length < 3) {
      return 'Username has to be at least 3 characters long.';
    }
    else if (username.length > 24) {
      return 'Username cannot be longer than 24 characters.';
    }
    else if (!regexAlphanumericOnly.hasMatch(username)) {
      return 'Username can contain only letters and digits.';
    }

    return null;
  }
}


