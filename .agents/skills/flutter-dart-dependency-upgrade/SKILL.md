---
name: flutter-dart-dependency-upgrade
description: Perform a controlled, maintenance-only upgrade of Flutter and Dart dependencies in a monorepo, including regeneration of code and localizations and reconciliation of iOS/macOS CocoaPods (notably Firebase SDK versions). Intended for manual or scheduled dependency hygiene tasks, not for routine feature development.
license: See LICENSE file in repository root
compatibility: Requires Flutter (via FVM), CocoaPods, and the Sharezone CLI (sz). Intended for Flutter monorepos with iOS and macOS targets.
metadata:
  author: Sharezone UG (haftungsbeschränkt)
  version: "1.0"
---

## Goal

Safely upgrade Flutter/Dart dependencies across the repository, regenerate all derived artifacts, and ensure iOS and macOS CocoaPods (especially Firebase SDKs) are aligned.

---

## When to use

This skill is intended for **maintenance workflows**, not for normal feature development.

Activate this skill only when the user asks for "Upgrade my Flutter dependencies" or similar

---

## Procedure

### 1. Upgrade Flutter dependencies

Run from the repository root:

```bash
fvm flutter pub upgrade
```

---

### 2. Regenerate generated code

```bash
sz build_runner build
```

---

### 3. Regenerate localizations

```bash
sz l10n generate
```

---

### 4. Install CocoaPods (iOS and macOS)

Run CocoaPods for both platforms:

```bash
pod install --project-directory=app/ios
pod install --project-directory=app/macos
```

---

## Common failure: Firebase SDK version mismatch

### Example error

```text
[!] CocoaPods could not find compatible versions for pod "FirebaseAnalytics":
  In snapshot (Podfile.lock):
    FirebaseAnalytics (= 12.2.0)

  In Podfile:
    firebase_analytics (...) depends on FirebaseAnalytics (= 12.8.0)
```

### Root cause

The Firebase SDK version pinned in the Podfiles does not match the version required by the FlutterFire plugins.

In `app/ios/Podfile` and `app/macos/Podfile`, Firebase frameworks are pinned via Invertase git tags, for example:

```ruby
pod 'FirebaseFirestore',
  :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
  :tag => '12.2.0'
```

The error output indicates the **required SDK version** (e.g. `12.8.0`).

---

### Fix

1. Read the required Firebase SDK version from the error message (e.g. `12.8.0`).
2. Update **both** Podfiles (`app/ios/Podfile` and `app/macos/Podfile`) to use that version:

```ruby
pod 'FirebaseFirestore',
  :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
  :tag => '12.8.0'
```

3. Remove existing lockfiles:

```bash
rm -f app/ios/Podfile.lock app/macos/Podfile.lock
```

4. Reinstall CocoaPods:

```bash
pod install --project-directory=app/ios
pod install --project-directory=app/macos
```

Success is indicated by:

```text
Pod installation complete!
```

with no errors.

---

## Final checks

### 5. Format code

```bash
sz format
```

### 6. Run static analysis

```bash
sz analyze
```

### 7. Run tests

```bash
sz test
```

If golden tests (located in `**/test_goldens`) fail with less than 0.15% difference, update the golden files:

```bash
sz test --update-goldens
```

If non-golden tests fail, investigate and fix the issues.

Both commands must complete without errors.

---

## Checklist

- [ ] `fvm flutter pub upgrade`
- [ ] `sz build_runner build`
- [ ] `sz l10n generate`
- [ ] `pod install` (iOS)
- [ ] `pod install` (macOS)
- [ ] Firebase SDK versions aligned in both Podfiles
- [ ] `sz format`
- [ ] `sz analyze`
- [ ] `sz test`

---

## Notes

- If CocoaPods reports a **minimum deployment target** error, the required Firebase SDK may exceed the current iOS/macOS deployment target. Update the deployment target consistently across Podfiles and Xcode project settings before retrying.
- Always update **both** iOS and macOS Podfiles to the same Firebase SDK version.
