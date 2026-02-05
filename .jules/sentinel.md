## 2024-05-22 - Proper URI Construction
**Vulnerability:** Improperly encoded query parameters in `mailto` links allowed parameter injection.
**Learning:** String concatenation for URIs is dangerous even for simple schemes like `mailto` as it bypasses encoding.
**Prevention:** Always use `Uri()` constructor with `queryParameters` map which handles encoding automatically.
