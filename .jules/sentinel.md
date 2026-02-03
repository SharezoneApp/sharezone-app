## 2025-02-18 - Mailto Parameter Injection
**Vulnerability:** Parameter injection in `mailto` URI construction. Manual string concatenation allowed injecting arbitrary parameters via unencoded inputs (e.g., `&` in subject).
**Learning:** `Uri.parse` does not automatically encode query parameters when parsing a full URL string. `Uri(queryParameters: ...)` constructor must be used to ensure safe encoding.
**Prevention:** Always use `Uri` constructors with `queryParameters` map instead of string concatenation for building URLs with dynamic user input.
