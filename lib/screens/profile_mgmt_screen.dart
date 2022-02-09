import 'package:flutter/material.dart';

import '../services/auth_token.dart';
import '../services/signin_service.dart';
import '../widgets/about_button.dart';
import '../widgets/profile_image_widget.dart';
import '../widgets/signin_button.dart';
import '../widgets/signout_button.dart';
import '../widgets/signup_button.dart';
import '../widgets/user_info_button.dart';
import 'home.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileManagementScreenState();
  }
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final SignInService signupService = SignInService();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!AuthTokenUtils.isLoggedIn()) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You need to be logged in to see this page.",
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('User profile management'),
        actions: const [
          SignInButton(),
          UserInfoButton(),
          SignOutButton(),
          SignUpButton(),
          AboutButton()
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ProfileImageWidget(),
          ],
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
      title: const Text("Could not log in"),
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
