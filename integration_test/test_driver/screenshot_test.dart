import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

// adapted from https://blog.codemagic.io/flutter-automated-screenshot-testing/
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (screenshotName, screenshotBytes) async {
      final File image =
          await File('screenshots/$screenshotName.png').create(recursive: true);
      await image.writeAsBytes(screenshotBytes);
      return true; // report as success
    },
  );
}
