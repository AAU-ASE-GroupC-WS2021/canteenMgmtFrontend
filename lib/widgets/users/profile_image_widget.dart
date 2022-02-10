import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/auth/auth_token.dart';
import '../../services/avatar_service.dart';
import '../../services/auth/signin_service.dart';
import '../../services/auth/signup_service.dart';

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

  late bool _hasAvatar = false;
  late String _base64Avatar = "";

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
          AvatarService().getAvatar(_username).then((value) => {
                if (value != null)
                  {
                    super.setState(() {
                      _base64Avatar = value.avatar;
                      _hasAvatar = true;
                    }),
                  },
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
            pickNewImage();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: _hasAvatar
                ? Image.memory(
                    base64Decode(_base64Avatar),
                    height: 100,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/graphics/blank-avatar.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
          ),
        ),

        const SizedBox(height: 10), // space between buttons

        // Username
        Text('@' + _username,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.primaries.first.shade500,),),

        const SizedBox(height: 5), // space between buttons

        // User type
        Row(
          children: [
            const Text('Type: ',
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),),
            Text(_type,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.blueAccent,),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),

        const SizedBox(height: 20), //
        const Text('Profile management',
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),),

        const SizedBox(height: 10), // space between buttons

        // Change password button
        ElevatedButton(
          onPressed: () => {
            context.beamToNamed("/profile/password"),
          },
          child: const Text('Change password', style: TextStyle(fontSize: 10)),
        ),

        // Button: Remove avatar
        if (_hasAvatar) ...[
          const SizedBox(height: 10), // space between buttons

          ElevatedButton(
            onPressed: () => {
              AvatarService().deleteAvatar(_username).then((value) => {
                    super.setState(() {
                      _hasAvatar = false;
                    }),
                  }),
            },
            child: const Text('Delete avatar', style: TextStyle(fontSize: 10)),
          ),
        ],
      ],
    );
  }

  Future<bool> pickNewImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final imageBytes = await pickedFile?.readAsBytes();

    if (imageBytes == null) {
      return false;
    }

    final String imageBase64 = base64Encode(imageBytes);

    AvatarService().updateAvatar(_username, imageBase64).then((value) => {
          if (value)
            {
              super.setState(() {
                _base64Avatar = imageBase64;
                _hasAvatar = true;
              }),
            },
        });

    return true;
  }
}
