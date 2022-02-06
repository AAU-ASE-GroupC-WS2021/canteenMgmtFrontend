import 'package:canteen_mgmt_frontend/screens/home.dart';
import 'package:canteen_mgmt_frontend/services/signin_service.dart';
import 'package:canteen_mgmt_frontend/services/signup_service.dart';
import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileImageWidgetState();
  }
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  final SignInService signupService = SignInService();

  late String _username = "";
  late String _type = "";

  @override
  void initState() {
    super.initState();

    if (!AuthTokenUtils.isLoggedIn()) {
      return;
    }

    SignupService().getUserSelfInfo().then((value) => {
      super.setState(() {
        _username = value.username;
        _type = value.type;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {

    if (!AuthTokenUtils.isLoggedIn()) {
      return const Offstage(
        offstage: true,
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            // Browse new image!
          },
          child: Image.asset('assets/graphics/blank-avatar.png', height: 100, fit: BoxFit.contain),
        ),

        const SizedBox(height: 10), // space between buttons

        Text('@' + _username, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.primaries.first.shade500)),

        Row(
          children: [
            const Text('Type: ', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
            Text(_type, style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.blueAccent)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),

      ],
    );
  }
}
