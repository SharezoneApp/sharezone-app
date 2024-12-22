# sharezone_localizations

**Sharezone Localizations** generates easily accessible translatable strings for the Sharezone-App. This package leverages Flutter's [Internationalization (i18n)](https://docs.flutter.dev/development/accessibility-and-localization/internationalization) features, providing an easy interface for adding, generating, and accessing localized strings in your application.

Additionally:

- AppLocaleProviderBloc: Allows you to manage and switch the current locale at runtime.
- AppLocaleBuilder: Enables direct access to the current AppLocales enum value in your UI, making it straightforward to conditionally render widgets or styles based on the current locale.

## Table of Contents

- [sharezone\_localizations](#sharezone_localizations)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Accessing Localized Strings](#accessing-localized-strings)
    - [How to Add/Update Strings](#how-to-addupdate-strings)
  - [Generating Localizations](#generating-localizations)
    - [Flutter Gen-L10n Command](#flutter-gen-l10n-command)
    - [Using VS Code Task](#using-vs-code-task)

---

## Features

- Easy String Access: Access your translations using a simple extension (context.sl).
- Multiple Locales: Support multiple languages via .arb files.
- Automatic Code Generation: Easily generate localization delegates and associated code using the flutter gen-l10n tool (or a dedicated VS Code Task).
- Locale Management:
  - AppLocaleProviderBloc helps you access and manage the current locale in real time, allowing dynamic locale switching.
  - AppLocaleBuilder makes it simple to retrieve the current AppLocales enum value for conditional rendering.

---

## Usage

### Accessing Localized Strings

After you have generated your localizations (see [Generating Localizations](#generating-localizations)), you can access the strings via the BuildContext extension:

```dart
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.sl.common_actions_cancel),
      ),
      body: Center(
        child: Text(context.sl.common_actions_cancel),
      ),
    );
  }
}
```

Where `common_actions_cancel` is the key from your .arb file (e.g., `app_en.arb`).  
Use it as `context.sl.common_actions_cancel`.

To manage or observe locale changes:

- AppLocaleProviderBloc can be injected in your widget tree to handle locale switching logic.
- AppLocaleBuilder can be used to rebuild widgets whenever the locale changes and provides the current AppLocales enum value.

---

### How to Add/Update Strings

1. Open your `.arb` file for the corresponding locale (e.g., `l10n/app_en.arb` for English).
2. Add a new key-value pair. For example:
   ```json
   {
     "common_actions_cancel": "Cancel"
   }
   ```
3. (Optional) Add placeholders if needed:
   ```json
   {
     "welcome_message": "Hello, {userName}!",
     "@welcome_message": {
       "description": "A welcome message for the user",
       "placeholders": {
         "userName": {}
       }
     }
   }
   ```

This allows you to dynamically inject parameters (for example userName) into the string.

4. Repeat the above steps in each relevant .arb file (e.g., app_de.arb, app_es.arb, etc.) to keep translations up to date across your app. (Optionally you can use packages like arb_translate for auto translations)

## Generating Localizations

After updating or creating .arb files, regenerate the localizations so Flutter can reflect the changes.

### Flutter Gen-L10n Command

Run inside this package:

```bash
flutter gen-l10n
```

### Using VS Code Task

If you have a VS Code task called "Generate l10n for sharezone_localizations", you can:

1. Open the Command Palette (⇧⌘P on macOS / Ctrl+Shift+P on Windows).
2. Select "Tasks: Run Task".
3. Choose "Generate l10n for sharezone_localizations".

This task runs `flutter gen-l10n` with your chosen configuration.
