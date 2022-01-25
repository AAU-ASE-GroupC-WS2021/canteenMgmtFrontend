import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../models/signup.dart';
import '../services/signup_service.dart';
import '../widgets/signup_widget.dart';

import '../widgets/about_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupService signupService = SignupService();
  late Future<List<Signup>> existingProfiles;

  @override
  void initState() {
    super.initState();
    existingProfiles = signupService.fetchDishes();
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a new profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 300.0,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: usernameController,
                    ),
                    const SizedBox(height: 20), // space between buttons
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20), // space between buttons
                    ElevatedButton(
                      onPressed: () => {
                      signupService.createProfile(usernameController.text, passwordController.text)
                        .then((value) => {
                        if (value) {
                          context.beamToNamed('/signup-finished')
                        }
                        else {
                          showAlertDialog("Could not create profile!")
                        }
                      })
                        .onError((error, stackTrace) => {
                        showAlertDialog("Unknown error occured while trying to create a new profile.\nPlease refresh the page and try again.!")
                      })
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(String error) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () { Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cannot create profile"),
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
}
