import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Take a screenshot and save it as screenshots/[screenshotName].png.
///
/// Note that this only works with the extended flutter driver.
// adapted from https://blog.codemagic.io/flutter-automated-screenshot-testing/
Future<List<int>> screenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester, {
  String name = 'screenshot',
}) async {
  // `Platform.isAndroid` causes errors for flutter web
  // and lazy evaluation does not seem to do the trick, therefore nested ifs
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      // only required for android
      await binding.convertFlutterSurfaceToImage();
    }
  }

  return await binding.takeScreenshot(name);
}
