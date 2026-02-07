# Agents

## Project Overview

Sharezone is a collaborative school organization app for iOS, Android, macOS and web built with Flutter.

## Repository Overview

- **.github/**: Our automated CI/CD pipeline
- **app/**: The main "Sharezone" app
- **lib/**: A place for our internal Dart/Flutter packages. Used to modularize and share code between app, website and admin console.
- **docs/**: Our end user documentation https://docs.sharezone.net, built with Nextra.
- **website/**: Our sharezone.net website (not the web app) built with Flutter.
- **console/**: Our admin console used by the Sharezone team for support / administrative tasks. Also built with Flutter.
- **tools/sz_repo_cli/**: Our custom `sz` Dart CLI used by developers and CI/CD pipelines.
  Helps with tasks like testing, analyzing, building, deploying etc.

This repository doesn't contain the backend code.

## Running the app

### Android, iOS & macOS

```sh
cd app
fvm flutter run --flavor dev --target lib/main_dev.dart
```

### Web

```sh
cd app
fvm flutter run --target lib/main_dev.dart
```

This will use our hosted development backend.

## Tests

Make sure your changes are tested. Write helpful and meaningful tests. Do not write useless tests.

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

You can also run tests for a specific directory or file (helpful for debugging):

```sh
# Run all unit & widget tests in the app directory
fvm flutter test app/test/

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
# IMPORTANT: Navigate to the directory where the test_goldens directory is located.
cd app # or ./lib/sharezone_widgets, ./lib/feedback_shared_implementation, etc.

# Run a single golden test file or directory
fvm flutter test test_goldens/grades/pages/grades_page/grades_page_test.dart
```

> [!NOTE]
> Golden tests currently only work on macOS due to rendering differences across platforms. On other platforms, the golden tests will be skipped.

To generate (or update) golden files, use:

```sh
# Generate golden files for all tests:
sz test --update-goldens --only-goldens
```

## Formatting

```sh
sz format
```

## Internationalization (i18n / l10n)

We organize our multi-language support in the `lib/sharezone_localizations` package.

### Adding new strings

1. Add the new string to `lib/sharezone_localizations/l10n/app_de.arb`. This is our default language.
2. Add the new string to `lib/sharezone_localizations/l10n/app_en.arb`. Metadata (e.g. `@your_new_string`) should only be added to the German file.
3. Run `sz l10n generate` to generate the Dart files for the new string.

### Use new strings

1. Add `import 'package:sharezone_localizations/sharezone_localizations.dart';` to the file where you want to use the new string.
2. Use the new string like this: `context.l10n.your_new_string`.

Do not add `SharezoneLocalizations` to business logic. Only use it in the UI.

## Style Guide

Follow the Effective Dart style guide.

Do not use `SharezoneContext` for new code. This is legacy code.
For new features, we use `Provider` for state management. `BlocProvider` is legacy code.
Keep business logic out of the UI. Use `Provider` for state management.
