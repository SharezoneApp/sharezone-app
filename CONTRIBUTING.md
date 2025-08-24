# Contributing to Sharezone

_Note: The `CONTRIBUTING.md` is in the process of being made. See [#28](https://github.com/SharezoneApp/sharezone-app/issues/28) for the missing sections._

## Welcome

We love that you are interested in contributing to Sharezone 💙 There are many ways to contribute, and we appreciate all of them. This document gives a rough overview of how you can contribute to Sharezone and which steps you need to follow to set up the development environment.

- [How to set up your development environment](#how-to-set-up-your-development-environment)

If you have any questions, please join our [Discord](https://sharezone.net/discord).

## How to set up your development environment

If you would like to contribute to our code, please follow the introduction to set up your development environment.

### Operating system

_tl;dr: We recommend macOS._

You can use the operating system you like. But we recommend to use macOS because you might have some issues with other operating systems.

#### Known issues:

- Golden tests are only passing with macOS
- The Sharezone CLI (used for development) only officially supports macOS and Windows (should also work with other operating systems, but might cause problems in some cases)

If you discover unknown issues that are related to the operating system, please submit a new ticket on [GitHub](https://github.com/SharezoneApp/sharezone-app/issues/new/choose).

### IDE

_tl;dr: We recommend VS Code._

Flutter supports IDE support for [VS Code](https://code.visualstudio.com/) and [Android Studio](https://developer.android.com/studio). We support only VS Code. This doesn't mean you can't use other IDEs, like Android Studio. But you might need to set up more configuration steps that aren't documented by us (like launch configurations).

We added some files from the `.vscode` folder to this repository. This ensures that all VS Code users have the same VS Code settings (like formatting, launch configurations, etc.) for this repository.

### Flutter

Our Sharezone app uses the [Flutter](https://flutter.dev) framework. In order to run tests, compile the app, etc. you need to setup Flutter.

Please follow the official documentation: [Install Flutter](https://docs.flutter.dev/get-started/install)

### Java

To build the Android app, you must have **Java 17** installed. You can download Java 17 from the [official website](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html).

In case you don't want to build the Android app, you can skip this step.

### Sharezone CLI

We have written our own CLI to manage our repository. Common use cases for the CLI are:

- Get all Flutter/Dart packages for all packages inside this repository (`sz pub get`)
- Run all tests for all packages inside this repository (`sz test`)
- Analyze all packages inside this repository (`sz analyze`)

#### macOS

Execute the following steps to install the Sharezone CLI:

1. [Clone this repository](#clone-this-repository)
2. Navigate to the repository (`cd sharezone-app`)
3. Run `dart pub get -C tools/sz_repo_cli`
4. Add the `./bin` to your environment variables
5. Restart your terminal

You should now be able to run `sz` or `sharezone` in your terminal.

#### Windows

Execute the following steps to install the Sharezone CLI:

1. [Clone this repository](#clone-this-repository)
2. Navigate to the repository (`cd sharezone-app`)
3. Run `dart pub get -C tools/sz_repo_cli`
4. Add the `./bin` to your PATH environment variables ([tutorial](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/))
5. Restart your terminal / code editor

You should now be able to run `sz` or `sharezone` in your terminal.

### Clone this repository

Before you can clone this repository, you need to install [git](https://git-scm.com/). After installing `git`, run this command:

```sh
git clone https://github.com/SharezoneApp/sharezone-app.git
```

After cloning the repository, we recommend executing the following steps:

1. Get all dependencies with `sz pub get`

### Flutter Version Management (FVM)

We use [FVM](https://fvm.app) to have a consistent Flutter version across the developers and our CI/CD. You find in `.fvmrc` the Flutter, which we currently using.

To install & use FVM, follow the following steps:

1. Install FVM by running `dart pub global activate fvm` or using the other installation methods (see [FVM docs](https://fvm.app/docs/getting_started/installation))
2. Navigate to the root of the repository
3. Run `fvm install` (This installs the Flutter version from `.fvmrc`)

When you are using VS Code, no further steps should be necessary. However, when you are using Android Studio, you need to configure your IDE to use the Flutter version of FVM. Follow the [official documentation](https://fvm.app/docs/getting_started/configuration#android-studio) to configure Android Studio.

### FlutterFire CLI

If you want to use build the macOS app, you need to install the [FlutterFire CLI](https://pub.dev/packages/flutterfire_cli). This CLI is used during the build process.

To install the FlutterFire CLI, execute the following command:

```sh
fvm flutter pub global activate flutterfire_cli 1.3.1
```

Make sure, you have the 0.3.0-dev.19 version or higher installed. You can check the version by running `flutterfire --version`.

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

This command runs the app in the development mode. Keep in mind that the app will not use our production backend. Instead, it will use the development backend. This means that you can't use the app with your production account. You need to create a new account on the development backend.
