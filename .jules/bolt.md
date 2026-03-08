
## 2024-05-20 - [Performance vs Security in Randomization]
**Learning:** `Random.secure()` has significant overhead compared to `Random()` (~50x slower for small string generation in Dart). The `O(N^2)` string concatenation (`+=`) penalty is another hidden bottleneck in random string generators.
**Action:** When refactoring random generators, combine `String.fromCharCodes` (with a pre-allocated `List<int>`) for `O(N)` speed with a top-level shared `Random` instance. For security-sensitive values (like IDs/tokens), use a shared `Random.secure()`; for non-sensitive values, use a shared `Random()`.
