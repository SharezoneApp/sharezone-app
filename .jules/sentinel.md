## 2026-02-04 - Email Content Injection in mailto Links
**Vulnerability:** Found manual string concatenation for constructing `mailto` URIs in `UrlLauncherExtended`. This allowed parameter injection (e.g., injecting `cc`, `bcc`, or overriding `body`) via unencoded input fields like `subject`.
**Learning:** `Uri.parse` works on an *already encoded* string. If you build the string manually with unencoded user input, you are bypassing encoding protections.
**Prevention:** Always use `Uri` constructors (e.g., `Uri(scheme: 'mailto', queryParameters: ...)`), which handle encoding automatically. Avoid string concatenation for URIs.
