# Contributing to Sharezone
_Note: The `CONTRIBUTING.md` is in the process of making. See [#28](https://github.com/SharezoneApp/sharezone-app/issues/28) for the missing sections._

## Welcome
We love, that you are interested in contributing to Sharezone 💙 There are many ways to contribute and we appreciate all of them. This document gives a rough overview of how you can contribute to Sharezone and which steps you need to follow to set up the development environment.

* [How to set up your development environment](#how-to-set-up-your-development-environment)

If you have ans questions, please join our [Discord](https://sharezone.net/discord).

## How to set up your development environment
If you would like to contribute to our code, please follow the introduction to set up your development environment.

### Operating system
_tl:dr: We recommend macOS._

You can use the operating system you like. But we recommend to use macOS because you might have some issues with other operating systems.

**Known issues:**
* Golden tests are only passing with macOS
* The Sharezone CLI (used for development) only officially supports macOS and Windows (should also work with other operating systems, but might cause problems in some cases)

If you discover unknown issues which are related to the operating system, please submit a new ticket on [GitHub](https://github.com/SharezoneApp/sharezone-app/issues/new/choose).

### IDE
_tl:dr: We recommend VS Code._

Flutter supports IDE support for [VS Code](https://code.visualstudio.com/) and [Android Studio](https://developer.android.com/studio). We support only VS Code. This doesn't mean you can't use other IDEs like Android Studio. But you might need set up more configuration steps which aren't documented by us (like launch configurations).

We added some files of the `.vscode` folder to this repository. This ensures that all VS Code users have the same VS Code settings (like formatting, launch configurations, etc.) for this repository.

### Flutter
Our client uses the [Flutter](https://flutter.dev) framework. In order to run tests, compile the app, etc. you need to setup Flutter.

Please follow the official documentation: [Install Flutter](https://docs.flutter.dev/get-started/install)

### Sharezone CLI
We written our own CLI to manage our repository. Common use cases for the CLI are:
* Get all Flutter/Dart packages for all packages inside this repository (`sz packages get`)
* Run all tests for all packages inside this repository (`sz test`)
* Analyze all packages inside this repository (`sz analyze`)

Execute the following steps to install the Sharezone CLI:
1. [Clone this repository](#clone-this-repository)
2. Navigate to the repository (`cd sharezone-app`)
3. Run `pub global activate --source path "tools/sz_repo_cli/"`
4. Add the `./bin` to your environment variables
5. Restart your terminal

### Clone this repository
Before you can clone this repository, you need to install [git](https://git-scm.com/). After installing `git`, run this command:

```sh
git clone https://github.com/SharezoneApp/sharezone-app.git
```

After cloning the repository, we recommend to execute the following steps:
1. Get all dependencies with `sz packages get`