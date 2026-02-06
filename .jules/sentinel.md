## 2025-02-19 - Mailto Parameter Injection

**Vulnerability:** `tryLaunchMailOrThrow` used string concatenation to build `mailto` URIs, allowing parameter injection (e.g., injecting `&body=` via the subject).
**Learning:** Manual URI construction via string concatenation is prone to injection vulnerabilities because it bypasses automatic encoding.
**Prevention:** Always use the `Uri` constructor with `queryParameters` (or `query`) to ensure proper encoding of all URI components.
