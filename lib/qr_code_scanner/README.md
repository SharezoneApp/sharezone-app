# qr_code_scanner

A wrapper around the [mobile_scanner](https://pub.dev/packages/mobile_scanner)
package with a custom UI to display a scan area, a description, etc.

## Platform Support

| Android | iOS | macOS | Web |
| :-----: | :-: | :---: | :-: |
|   ✔️     |  ✔️  |   ✔️   |  ✔️  |

**Android:** SDK +21
**iOS:** +11.0
**macOS:**: +10.13

To get more information about the platform support, checkout the `README.md` of
[mobile_scanner](https://github.com/juliansteenbakker/mobile_scanner).

## Setup

### Web

Add this `script` to the `head` of your `web/index.html`.
```html
<!-- Required for the "mobile_scanner" package -->
<script src="https://unpkg.com/@zxing/library@0.19.1" type="application/javascript"></script>
```

_Note: It's recommended to download the library and host it yourself (more GDPR friendly)._

### macOS

Add "Camera" permission in XCode -> Signing & Capabilities.