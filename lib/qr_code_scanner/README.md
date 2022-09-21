# qr_code_scanner

A wrapper around the [mobile_scanner](https://pub.dev/packages/mobile_scanner) package with a custom UI to display a scan area, a description, etc.

## Setup

### Web

Add this `script` to the `head` of your `web/index.html`.
```html
<!-- Package "mobile_scanner" depends on "jsQR" -->
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
```