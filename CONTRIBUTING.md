# Contributing to Sharezone

_Note: The `CONTRIBUTING.md` is in the process of making. See [#28](https://github.com/SharezoneApp/sharezone-app/issues/28) for the missing sections._

## Welcome

We love, that you are interested in contributing to Sharezone 💙 There are many ways to contribute and we appreciate all of them. This document gives a rough overview of how you can contribute to Sharezone and which steps you need to follow to set up the development environment.

* [How to set up your development environment](#how-to-set-up-your-development-environment)

If you have any questions, please join our [Discord](https://sharezone.net/discord).

## How to set up your development environment

If you would like to contribute to our code, please follow the introduction to set up your development environment.

### Operating system

_tl;dr: We recommend macOS._

You can use the operating system you like. But we recommend to use macOS because you might have some issues with other operating systems.

#### Known issues:

* Golden tests are only passing with macOS
* The Sharezone CLI (used for development) only officially supports macOS and Windows (should also work with other operating systems, but might cause problems in some cases)

If you discover unknown issues which are related to the operating system, please submit a new ticket on [GitHub](https://github.com/SharezoneApp/sharezone-app/issues/new/choose).

### IDE

_tl;dr: We recommend VS Code._

Flutter supports IDE support for [VS Code](https://code.visualstudio.com/) and [Android Studio](https://developer.android.com/studio). We support only VS Code. This doesn't mean you can't use other IDEs like Android Studio. But you might need set up more configuration steps which aren't documented by us (like launch configurations).

We added some files of the `.vscode` folder to this repository. This ensures that all VS Code users have the same VS Code settings (like formatting, launch configurations, etc.) for this repository.

### Flutter

Our Sharezone app uses the [Flutter](https://flutter.dev) framework. In order to run tests, compile the app, etc. you need to setup Flutter.

Please follow the official documentation: [Install Flutter](https://docs.flutter.dev/get-started/install)

### Sharezone CLI

We written our own CLI to manage our repository. Common use cases for the CLI are:
* Get all Flutter/Dart packages for all packages inside this repository (`sz pub get`)
* Run all tests for all packages inside this repository (`sz test`)
* Analyze all packages inside this repository (`sz analyze`)

#### macOS

Execute the following steps to install the Sharezone CLI:
1. [Clone this repository](#clone-this-repository)
2. Navigate to the repository (`cd sharezone-app`)
3. Run `dart pub get -C tools/sz_repo_cli`
4. Add the `./bin` to your environment variables
5. Restart your terminal

You should now be able to run `sz` or `sharezone` in your terminal. 

#### Windows

At the moment, there is no Windows support for a command alias like `sz` or `sharezone`. Instead you need to run `dart run tools/sz_repo_cli/bin/sz_repo_cli.dart`, like `dart run tools/sz_repo_cli/bin/sz_repo_cli.dart pub get`. Please keep this in mind when reading commands like `sz pub get`.

Execute the following steps to install the Sharezone CLI:
1. [Clone this repository](#clone-this-repository)
2. Navigate to the repository (`cd sharezone-app`)
3. Run `dart pub get -C tools/sz_repo_cli`

You should now be able to run `dart run tools/sz_repo_cli/bin/sz_repo_cli.dart`.

### Clone this repository

Before you can clone this repository, you need to install [git](https://git-scm.com/). After installing `git`, run this command:

```sh
git clone https://github.com/SharezoneApp/sharezone-app.git
```

After cloning the repository, we recommend to execute the following steps:
1. Get all dependencies with `sz pub get`

### Flutter Version Management (FVM)

We use [FVM](https://fvm.app) to have a consistent Flutter version across the developers and our CI/CD. You find in `.fvm/fvm_config.json` the Flutter, which we currently using.

To install & use FVM, follow the following steps:
1. Install FVM by running `dart pub global activate fvm` or use the other installation methods (see [FVM docs](https://fvm.app/docs/getting_started/installation))
2. Navigate to the root of the repository
3. Run `fvm install` (This installs the Flutter version from `.fvm/fvm_config.json`)

When you are using VS Code, no further steps should be necessary, because we included the `.vscode/setting.json` to git. However, when you are using Android Studio, you need to configure your IDE to use the Flutter version of FVM. Follow the [official documentation](https://fvm.app/docs/getting_started/configuration#android-studio) to configure Android Studio.

## Running the app

After you have set up your development environment, you can run the app. To run the app, you need to execute the following command:

### Android & iOS

```sh
fvm flutter run --flavor dev --target lib/main_dev.dart
```

### Web & macOS

```sh
fvm flutter run --target lib/main_dev.dart
```
