![Sharezone Banner with two phones](https://user-images.githubusercontent.com/29028262/151260826-4d13664c-8269-442c-bf78-1197899afffb.png)

## Download Sharezone

| Android                                                                                                                                                                                                                            | iOS                                                                                                                                                                                                                     | macOS                                                                                                                                                                                                                     | Web                                                                                                                                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href='https://play.google.com/store/apps/details?id=de.codingbrain.sharezone'><img width=200 alt='Get Sharezone on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/> | <a href='https://apps.apple.com/de/app/sharezone/id1434868489'><img width=150 alt='Get Sharezone for iOS' src='https://user-images.githubusercontent.com/24459435/172480740-d70aff84-fcb6-4f4a-bbd1-a3e2fa58f3a9.svg'/> | <a href='https://apps.apple.com/de/app/sharezone/id1434868489'><img width=190 alt='Get Sharezone for macOS' src='https://user-images.githubusercontent.com/24459435/172480858-f2631b6c-c56d-47d2-abe5-84f735edbe85.svg'/> | <a href='https://web.sharezone.net'><img width=170 alt='Open the Sharezone web app' src='https://user-images.githubusercontent.com/29028262/151261789-ac4d7496-ff14-4ef0-8d9f-c9fee72cb302.png'/> |

[Sharezone](https://sharezone.net) is a collaborative school organization app for iOS, Android, macOS and web.\
With Sharezone pupils, teachers and even parents can use the following features together as a class:

- 📚 Homework diary
- 🕒 Timetable
- 📅 Calendar
- 💬 Information sheets
- 📁 Files
- ⭐️ Grades (not shared with the class)

Sharezone is currently only available in German.  
We might expand to more languages and regions in the future 🌍🚀

[Join our Discord](https://sharezone.net/discord) for active discussions, announcements, feedback and more!

## Repository Overview

- 🛠 **.github/**: Our fully automated CI/CD pipeline using GitHub Actions and [`codemagic-cli-tools`](https://github.com/codemagic-ci-cd/cli-tools).
  Used to publish alpha, beta, and stable versions to Google Play Store (Android), App Store (iOS, macOS), TestFlight (iOS, macOS), and Firebase Hosting (Web).

- 📱 **app/**: The main "Sharezone" app, created with [Flutter](https://flutter.dev).
- 📚 **lib/**: A place for our internal Dart/Flutter packages. Used to modularize and share code between app, website and admin console.

- 📖 **docs/**: Our end user documentation [docs.sharezone.net](https://docs.sharezone.net), built with [Nextra](https://nextra.site/).
  Is currently pretty sparse, but we are working on improving it.

- 🌐 **website/**: Our [sharezone.net](https://sharezone.net) website (not the web app) built with Flutter.

- 🔧 **console/**: Our admin console used by the Sharezone team for support / administrative tasks. Also built with Flutter.

- 🛠️ **tools/sz_repo_cli/**: Our custom `sz` Dart CLI used by developers and CI/CD pipelines.
  Helps with tasks like testing, analyzing, building, deploying etc.

## Running the app

To run the locally, please read the instructions in our [CONTRIBUTIND.md](./CONTRIBUTIND.md#running-the-app).

## Tests

We use several types of tests to ensure the quality and stability of Sharezone:

- [Unit Tests](https://docs.flutter.dev/cookbook/testing/unit/introduction): Verify the logic of individual functions or classes in isolation.
- [Widget Tests](https://docs.flutter.dev/cookbook/testing/widget/introduction): Test widgets’ UI and interaction behavior without running the full app.
- [Golden Tests](https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html): Compare rendered widgets to “golden” reference images to detect unintended visual changes.
- [Integration Tests](https://docs.flutter.dev/cookbook/testing/integration/introduction): Run the app on a device or emulator to test end-to-end flows.

To run the tests, please read the instructions in our [CONTRIBUTIND.md](./CONTRIBUTIND.md#tests).

## Open-Source

This project is licensed under [EUPL v1.2](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12) or later.\
For some files other licenses or terms (regarding e.g. copyright) might apply. This can be indicated, for example, by a notice included in the file itself or a README in a parent folder.\
Guidelines for users and developers for the EUPL v1.2 can be found [here](https://joinup.ec.europa.eu/collection/eupl/guidelines-users-and-developers).

## Contribute

To contribute just open a PR and sign the [Contributor License Agreement](https://github.com/SharezoneApp/public/wiki/Sharezone-CLA-Overview).  
A bot will automatically ask you to accept the CLA when a PR is opened if you haven't already.

We have more instructions to help you get started in the [CONTRIBUTING.md](CONTRIBUTING.md).

## Follow us

- [Instagram](https://www.instagram.com/sharezone.app/)
- [Twitter](https://twitter.com/SharezoneApp)
- [Discord](https://sharezone.net/discord)
