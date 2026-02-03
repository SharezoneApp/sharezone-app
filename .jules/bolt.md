## 2025-05-19 - FutureBuilder Anti-pattern
**Learning:** Found usage of `FutureBuilder` where the future was created inside the `build` method (`listStream.first`). This causes the future to be recreated and re-subscribed on every rebuild, leading to performance overhead and potential flickering.
**Action:** Always check `FutureBuilder` usage. The future should be obtained in `initState` or `didUpdateWidget` and stored in a state variable to prevent re-execution on rebuilds.
