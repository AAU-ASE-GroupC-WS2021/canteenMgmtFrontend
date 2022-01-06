# Canteen Management Frontend

Frontend for our canteen management system.  
Built with flutter web.

The QR scanner feature requires _https_ to be enabled
(see [getUserMedia()](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia)
and [Secure context restrictions](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts/features_restricted_to_secure_contexts#secure_context_restrictions_that_vary_by_browser)).

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
