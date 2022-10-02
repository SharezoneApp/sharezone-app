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
<!-- Package "mobile_scanner" depends on "jsQR" -->
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
```

### macOS

Add "Camera" permission in XCode -> Signing & Capabilities.