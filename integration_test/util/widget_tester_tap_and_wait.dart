import 'package:flutter_test/flutter_test.dart';

import 'widget_tester_wait_for.dart';

extension WidgetTesterTapAndWait on WidgetTester {
  /// Tap some element and wait until animations are over.
  ///
  /// If [waitUntil] is provided, it will [waitFor] the element to appear.
  /// Note that [timeout] and [steps] are only relevant to [waitFor].
  Future<void> tapAndWait(
    Finder finder, {
    Finder? waitUntil,
    Duration timeout = const Duration(seconds: 30),
    Duration steps = const Duration(milliseconds: 200),
  }) async {
    await tap(finder);
    await pumpAndSettle();

    if (waitUntil != null) waitFor(waitUntil, timeout: timeout, steps: steps);
  }
}
