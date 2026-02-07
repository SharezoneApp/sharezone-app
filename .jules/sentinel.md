## 2026-02-07 - URL Scheme Validation

**Vulnerability:** The application was allowing arbitrary URL schemes (e.g., `javascript:`, `file:`) in `launchURL` utility, potentially enabling XSS or local file access.
**Learning:** `url_launcher`'s `launchUrl` does not inherently block dangerous schemes on all platforms, especially on web where `javascript:` can execute.
**Prevention:** Implement an explicit allowlist of safe schemes (`http`, `https`, `mailto`, `tel`, `sms`) before launching any user-controlled URL.
