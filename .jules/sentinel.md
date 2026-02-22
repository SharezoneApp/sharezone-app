## 2025-05-31 - Weak Randomness in ID Generation
**Vulnerability:** Core ID generation (`Id.generate` in `common_domain_models`) and `randomIDString` in `sharezone_utils` were using `Random()` (insecure LCG) instead of `Random.secure()`.
**Learning:** `Random()` is predictable and not suitable for security-sensitive contexts like generating IDs or tokens, which could lead to enumeration attacks.
**Prevention:** Use `Random.secure()` for any random value generation that might be security-sensitive. Check default providers in library functions.
