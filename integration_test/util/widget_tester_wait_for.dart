import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterWaitFor on WidgetTester {
  /// Wait until an element is found or the time runs out.
  Future<void> waitFor(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    Duration steps = const Duration(milliseconds: 200),
  }) async {
    final timer = Timer(
      timeout,
      () => throw TimeoutException("Pump until has timed out"),
    );

    bool found = false;
    while (!found) {
      await Future.delayed(steps);
      await pumpAndSettle();
      found = any(finder);
    }
    timer.cancel();
  }
}
