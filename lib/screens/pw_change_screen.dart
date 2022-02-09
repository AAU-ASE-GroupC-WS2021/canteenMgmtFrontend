import 'password_finished.dart';
import '../services/auth_token.dart';
import '../services/signup_service.dart';
import '../widgets/about_button.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class PwChangeScreen extends StatefulWidget {
  const PwChangeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PwChangeScreenState();
  }
}

class _PwChangeScreenState extends State<PwChangeScreen> {
  final SignupService signupService = SignupService();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final passwordControllerOld = TextEditingController();
  final passwordControllerNe1 = TextEditingController();
  final passwordControllerNe2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!AuthTokenUtils.isLoggedIn()) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You need to be logged in to view this page!",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20), // space between buttons
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                ),
                child: const Text('Go to the Homepage'),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
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
                      obscureText: true,
                      controller: passwordControllerOld,
                      validator: (value) => validateOldPassword(value),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: 'Current password',
                      ),
                    ),
                    const SizedBox(height: 20), // space between buttons

                    TextFormField(
                      obscureText: true,
                      controller: passwordControllerNe1,
                      validator: (value) => validateNewPassword(value),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: 'New password',
                      ),
                    ),
                    const SizedBox(height: 20), // space between buttons

                    TextFormField(
                      obscureText: true,
                      controller: passwordControllerNe2,
                      validator: (value) => validateNewPasswordRepeated(value),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: 'Repeat new password',
                      ),
                    ),
                    const SizedBox(height: 20), // space between buttons

                    ElevatedButton(
                      onPressed: () => {
                      if (_formKey.currentState!.validate()) {

                        signupService.getUserSelfInfo().then((value) =>
                        {

                          signupService.updatePassword(value.username, passwordControllerOld.text, passwordControllerNe2.text)
                              .then((value) => {
                            if (value == null) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PasswordFinishedScreen())),
                            }
                            else {
                              showAlertDialog(value)
                            },
                          })
                              .onError((error, stackTrace) => {
                            showAlertDialog("Unknown error occurred while trying to change password.\nPlease refresh the page and try again!"),
                          }),
                        })
                            .onError((error, stackTrace) => {
                          showAlertDialog("Unknown error occurred while trying to read user credentials.\nPlease refresh the page and try again!"),
                        }),

                      },
                      },
                      child: const Text('Update password'),
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
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Could not update password"),
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

  String? validateOldPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password field cannot be empty.';
    } else if (password.length < 9) {
      return 'Password has to be at least 9 characters long.';
    } else if (password.length > 64) {
      return 'Password cannot be longer than 64 characters.';
    }

    return null;
  }

  static final regexAtLeastOneUppercaseLetter = RegExp(r'(?=.*[A-Z])');
  static final regexAtLeastOneLowercaseLetter = RegExp(r'(?=.*[a-z])');
  static final regexAtLeastOneDigit = RegExp(r'(?=.*[0-9])');
  static final regexAlphanumericOnly = RegExp(r'^[a-zA-Z0-9]+$');

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password field cannot be empty.';
    } else if (password.length < 9) {
      return 'Password has to be at least 9 characters long.';
    } else if (password.length > 64) {
      return 'Password cannot be longer than 64 characters.';
    }

    String otherRequirements = "";

    if (!regexAtLeastOneUppercaseLetter.hasMatch(password)) {
      otherRequirements +=
          'Password must contain at least one uppercase letter.\n';
    }

    if (!regexAtLeastOneLowercaseLetter.hasMatch(password)) {
      otherRequirements +=
          'Password must contain at least one lowercase letter.\n';
    }

    if (!regexAtLeastOneDigit.hasMatch(password)) {
      otherRequirements += 'Password must contain at least one digit.\n';
    }

    return otherRequirements.isNotEmpty ? otherRequirements : null;
  }

  String? validateNewPassword(String? password) {
    if (validatePassword(password) != null) {
      return validatePassword(password);
    } else if (passwordControllerOld.text == passwordControllerNe1.text) {
      return 'New password cannot be the same as the current one!';
    }

    return null;
  }

  String? validateNewPasswordRepeated(String? password) {
    if (validatePassword(password) != null) {
      return validatePassword(password);
    } else if (passwordControllerNe1.text != passwordControllerNe2.text) {
      return 'Repeated password does not match the new one!';
    }

    return null;
  }
}
