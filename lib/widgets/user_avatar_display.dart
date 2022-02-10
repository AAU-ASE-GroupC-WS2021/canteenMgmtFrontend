import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/avatar_service.dart';

class UserAvatarDisplay extends StatefulWidget {
  const UserAvatarDisplay({Key? key, required this.username, this.height = 30})
      : super(key: key);

  final String username;
  final double height;

  @override
  State<StatefulWidget> createState() => _UserAvatarDisplayState();
}

class _UserAvatarDisplayState extends State<UserAvatarDisplay> {
  String _base64Avatar = "";

  @override
  void initState() {
    super.initState();
    GetIt.I.get<AvatarService>().getAvatar(widget.username).then((value) => {
          if (value != null)
            {
              setState(() {
                _base64Avatar = value.avatar;
              }),
            },
        });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: _base64Avatar != ""
          ? Image.memory(
              base64Decode(_base64Avatar),
              height: widget.height,
              fit: BoxFit.contain,
            )
          : Image.asset(
              'assets/graphics/blank-avatar.png',
              height: widget.height,
              fit: BoxFit.contain,
            ),
    );
  }
}
