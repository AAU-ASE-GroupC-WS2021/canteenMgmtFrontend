# Canteen Management Frontend

Frontend for our canteen management system. 

## Running

### Web (desktop)

[jsQR](https://github.com/cozmo/jsQR) (used by qr_code_scanner for web) only works with the HTML renderer.
Add `--web-renderer html` to run/build args.

Note: the HTML renderer is used by default on mobile devices.

### Web (mobile)

To test the web app on a mobile device, use

```sh
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000
```

then navigate to `<server ip>:5000` on your mobile device.
It may be necessary to reload the page at least once.

Note: in most modern browsers, camera usage is only allowed in secure contexts (`localhost` or `https://...`).
For debugging purposes, Chrome allows specifying exceptions using `chrome://flags/#unsafely-treat-insecure-origin-as-secure`.
