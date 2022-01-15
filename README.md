# Canteen Management Frontend

[![CircleCI](https://circleci.com/gh/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend/tree/main.svg?style=shield)](https://circleci.com/gh/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend/tree/main)
[![codecov](https://codecov.io/gh/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend/branch/main/graph/badge.svg?token=7XIIY93GYQ)](https://codecov.io/gh/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend)

Frontend for our canteen management system.  
Built with flutter web.

The QR scanner feature requires _https_ to be enabled
(see [getUserMedia()](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia)
and [Secure context restrictions](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts/features_restricted_to_secure_contexts#secure_context_restrictions_that_vary_by_browser)).

## Structure

See also dart/flutter [package layout conventions](https://dart.dev/tools/pub/package-layout).

- `lib/` main application sources
- `build/` _(generated)_ build artifacts
- `web/`, `android/`, `ios/` base files for respective device builds
- `test/`, `integration_test/` test code for widget and integration tests, resp.
- `test_driver/` setup for `flutter drive` (integration) tests
- `.idea/`, `.circleci/` configuration files for IntelliJ and CircleCI resp.

## Building from Source

1. [Set up flutter](https://docs.flutter.dev/get-started/install) (includes the dart SDK)
2. clone the repository
3. run `flutter build web --web-renderer html` in the project root

The artifact is found in `<project root>/build/web/`.

## Running and Debugging

### IntelliJ/Android Studio

In the [flutter toolbar](https://docs.flutter.dev/development/tools/android-studio#running-and-debugging) (top right by default),
select a device and the `main.dart` configuration and press either the _Run_ or _Debug_ button.

To run on other browsers and devices, select the `server` configuration and manually connect to `<host address>:5000`.

Note: in most modern browsers, camera usage is only allowed in secure contexts (`https://...` or `localhost`).
For debugging purposes, Chrome allows specifying exceptions using `chrome://flags/#unsafely-treat-insecure-origin-as-secure`.

### Terminal

In the following, replace `...` with `--web-renderer html`
(the qr_code_scanner package requires the [HTML renderer](https://docs.flutter.dev/development/tools/web-renderers) to work in web).

Run `flutter run ...` to open a debug view on a supported browser.  
Run `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000 ...` and manually connect to `<host address>:5000`.

## Running Tests

### Widget Tests

[Widget tests](https://docs.flutter.dev/testing#widget-tests) launch widgets in an optimized test environment.

Run `flutter test` (runs all files in `test/`)

### Integration Tests

[Integration tests](https://docs.flutter.dev/testing#integration-tests) launch the entire app on a real or emulated device/browser.
This is closer to real use than widget tests, but requires more effort to set up and runs slower.

1. Download [chromedriver](https://chromedriver.chromium.org/downloads)
2. Run `chromedriver --port=4444` (this is the default port for `flutter drive`)
3. Run `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/demo_test.dart -d web-server`

See also [Running Flutter Driver tests with Web](https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web)
and the `integration_test` [example app](https://github.com/flutter/flutter/tree/master/packages/integration_test/example).
