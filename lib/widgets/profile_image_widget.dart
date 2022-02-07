import 'dart:convert';
import 'dart:io';

import '../services/signin_service.dart';
import '../services/signup_service.dart';
import '../utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  bool _hasAvatar = true;
  String _base64Avatar = "";


  late File _image;
  final picker = ImagePicker();

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
            getImage().then((value) =>  {
              if (value) {
                // reload page
              },
            },
            );
          },
          child: _hasAvatar ?
          Image.memory(base64Decode(_base64Avatar), height: 100, fit: BoxFit.contain)
          :
          Image.asset('assets/graphics/blank-avatar.png', height: 100, fit: BoxFit.contain),
        ),

        const SizedBox(height: 10), // space between buttons

        Text('@' + _username, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.primaries.first.shade500)),

        Row(
          children: [
            const Text('Type: ', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
            Text(_type, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blueAccent)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),

      ],
    );
  }

  Future<bool> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    bool picked = false;

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        picked = true;
      }
    });

    return picked;
  }
}
