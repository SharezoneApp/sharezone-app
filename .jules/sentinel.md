## 2024-05-24 - [Insecure Randomness for Identifiers]

**Vulnerability:** Weak random number generation (`Random()`) used for IDs, secrets, tokens, or security-sensitive identifiers.
**Learning:** `Random()` uses a linear congruential generator or similar PRNG algorithm that can be predicted with enough observations. Attackers can figure out the internal state and guess past or future IDs, leading to potential ID enumeration, session hijacking, or predicting sensitive values.
**Prevention:** Use `Random.secure()` from `dart:math` for generating any ID, token, or security-critical random value.
