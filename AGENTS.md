# Agents

## Project Overview

Sharezone is a collaborative school organization app for iOS, Android, macOS and web.
With Sharezone pupils, teachers and even parents can use the following features together as a class:

- Homework diary
- Timetable
- Calendar
- Information sheets
- Files
- Grades (not shared with the class)

## Repository Overview

- **.github/**: Our fully automated CI/CD pipeline using GitHub Actions and `codemagic-cli-tools`.
  Used to publish alpha, beta, and stable versions to Google Play Store (Android), App Store (iOS, macOS), TestFlight (iOS, macOS), and Firebase Hosting (Web).
- **app/**: The main "Sharezone" app, created with Flutter.
- **lib/**: A place for our internal Dart/Flutter packages. Used to modularize and share code between app, website and admin console.
- **docs/**: Our end user documentation https://docs.sharezone.net, built with Nextra.
  Is currently pretty sparse, but we are working on improving it.
- **website/**: Our sharezone.net website (not the web app) built with Flutter.
- **console/**: Our admin console used by the Sharezone team for support / administrative tasks. Also built with Flutter.
- **tools/sz_repo_cli/**: Our custom `sz` Dart CLI used by developers and CI/CD pipelines.
  Helps with tasks like testing, analyzing, building, deploying etc.

## Running the app

After you have set up your development environment, you can run the app.

First change the working directory to the `app` folder by running:

```sh
cd app
```

To run the app, you can then execute the following command:

### Android, iOS & macOS

```sh
fvm flutter run --flavor dev --target lib/main_dev.dart
```

### Web

```sh
fvm flutter run --target lib/main_dev.dart
```

Use the Playwright Skill to use the web app.

## Tests

Make sure your changes are tested. Write helpful and meaningful tests. Do not write useless tests.

We use several types of tests to ensure the quality and stability of Sharezone:

- Unit Tests: Verify the logic of individual functions or classes in isolation.
- Widget Tests: Test widgets’ UI and interaction behavior without running the full app.
- Golden Tests: Compare rendered widgets to “golden” reference images to detect unintended visual changes.
- Integration Tests: Run the app on a device or emulator to test end-to-end flows.

### Executing all tests

You execute all tests (except integration tests) with the following command:

```sh
sz test
```

> [!NOTE]
> This command is relatively slow because it runs **all** tests across all packages. During development, you may want to only run a subset of tests to speed things up.

### Executing unit & widget tests

To run all unit and widget tests, use:

```sh
sz test --exclude-goldens
```

You can also run tests for a specific directory or file:

```sh
# Run all unit & widget tests in the app directory
fvm flutter test app/test/

# Run only tests for the "grades" feature
fvm flutter test app/test/grades

# Run a single test file
fvm flutter test app/test/grades/grades_service_test.dart
```

### Executing golden tests

To run only golden tests, execute:

```sh
sz test --only-goldens
```

You can also limit golden tests to specific directories or files:

```sh
# Run all golden tests for the app
fvm flutter test app/test_goldens/

# Run golden tests for the "grades" feature
fvm flutter test app/test_goldens/grades

# Run a single golden test file
fvm flutter test app/test_goldens/grades/pages/grades_page/grades_page_test.dart
```

> [!WARNING]
> Golden tests currently only pass on macOS due to rendering differences across platforms. Run `sz test --exclude-goldens` on other platforms.

To generate (or update) golden files, use:

```sh
# Generate golden files for all tests:
sz test --update-goldens

# Generate golden files for a directory, e.g. "grades"
fvm flutter test app/test_goldens/grades --update-goldens

# Generate golden files for a single file, e.g. grade_page_test.dart
fvm flutter test app/test_goldens/grades/pages/grades_page/grades_page_test.dart --update-goldens
```

### Executing integration tests

Please see [app/integration_test/README.md](./app/integration_test/README.md) for detailed instructions on how to run integration tests.

## Formatting

To format the code, run:

```sh
sz format
```

## Internationalization (i18n / l10n)

We organize our multi-language support in the `lib/sharezone_localizations` package.

### Adding new strings

1. Add the new string to `lib/sharezone_localizations/l10n/app_de.arb`. This is our default language.
2. Add the new string to `lib/sharezone_localizations/l10n/app_en.arb`.
3. Run `sz l10n generate` to generate the Dart files for the new string.

### Use new strings

1. Add `import 'package:sharezone_localizations/sharezone_localizations.dart';` to the file where you want to use the new string.
2. Use the new string like this: `context.l10n.your_new_string`.

## Style Guide

Please refer to our [style guide](./.gemini/styleguide.md) for information on topics such as:

- Markdown style
- Dart style
- Flutter style
