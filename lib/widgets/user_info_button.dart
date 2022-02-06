import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth.dart';

class UserInfoButton extends StatelessWidget {
  const UserInfoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Offstage(
        offstage: !state.authenticated,
        // TODO later: make the button dropdown or popup for more functions.
        child: ElevatedButton(
          child: Text('${state.username} (${state.type})'),
          // ignore: no-empty-block
          onPressed: () {
            // Do some action: either show a popup or dropdown, or go to the user profile page.
          },
        ),
      ),
    );
  }
}
