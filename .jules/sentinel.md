## 2026-02-09 - Sensitive Data Logging and Validation

**Vulnerability:** Logging of raw QR code data (containing session initiation tokens) via `dart:developer` log(), and lack of validation for QR code input.
**Learning:** `log()` statements intended for debugging can accidentally expose sensitive user tokens if left in production code. QR codes from external sources are untrusted input and must be validated before processing.
**Prevention:** Remove debug logs before committing. Validate all external inputs (like QR codes) against expected formats (e.g. alphanumeric) before passing them to business logic or backend services.
