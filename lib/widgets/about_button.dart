import 'package:flutter/material.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({Key? key}) : super(key: key);

  static const gitUrl = String.fromEnvironment('GIT_URL');
  static const gitBranch = String.fromEnvironment('GIT_BRANCH');
  static const commitHash = String.fromEnvironment('COMMIT_HASH');
  static const ciProvider = String.fromEnvironment('CI_PROVIDER');

  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info),
      onPressed: () {
        showAboutDialog(
          context: context,
          applicationName: 'Canteen Management',
          children: const [
            SelectableText(
              'Built' +
                  (ciProvider != '' ? ' by $ciProvider' : '') +
                  (gitUrl != '' ? ' from $gitUrl' : '') +
                  (gitBranch != '' ? ' (in $gitBranch)' : '') +
                  (commitHash != '' ? ' at $commitHash' : '') +
                  '\nConnecting to API at $backendUrl',
            ),
          ],
        );
      },
    );
  }
}
