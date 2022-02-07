import 'dart:ui';

import 'package:flutter_test/src/widget_tester.dart';

void useUHDResolution(WidgetTester tester) {
  tester.binding.window.physicalSizeTestValue = const Size(3840, 2160);
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
}
