# Integration Tests

Unit tests and widget tests are handy for testing individual classes, functions, or widgets. However, they generally don’t test how individual pieces work together as a whole, or capture the performance of an application running on a real device. These tasks are performed with integration tests.

Integration tests are written using the [integration_test](https://github.com/flutter/flutter/tree/master/packages/integration_test) package, provided by the SDK.

## How to run integration tests

In order to run the integration tests, you need specific credentials for the
Sharezone accounts. The reason for this is that this account has already some
data that are required for the tests. Please write Nils or Jonas a message on
our [Discord server](https://sharezone.net/discord) if you want to run the
integration tests, so that we can provide you with the credentials.

Alternatively, you can also create your own Sharezone account and add the
following data:

1. Create a school class called "10 A"
2. Create a course with the subject "Deutsch" and the name "Deutsch LK"
3. Create a course with the subject "Englisch" and the name "Englisch LK"
4. Create a course with the subject "Französisch" and the name "Französisch LK"
5. Create a course with the subject "Latein" and the name "Latein LK"
6. Create a course with the subject "Spanisch" and the name "Spanisch LK"
7. Add information sheet to the course "Deutsch LK" with the following title
   "German Course Trip to Berlin"
8. Add 6 lessons with the course "Deutsch LK"
9. Add 2 lessons with the course "Englisch LK"
10. Add 4 lessons with the course "Französisch LK"
11. Add 4 lessons with the course "Latein LK"
12. Add 4 lessons with the course "Spanisch LK"

### Mobile

You can run the integration tests using the `flutter test` command:

```sh
fvm flutter test \
  integration_test \
  --flavor dev \
  --dart-define \
  USER_1_EMAIL="YOUR@EMAIL.COM" \
  --dart-define \
  USER_1_PASSWORD="YOUR_PASSWORD"
```

### Android Device Testing

Our integration tests are designed to work with Firebase Test Lab and use Android instrumentation tests. You can run these tests locally using the following steps:

1. **Navigate to the Android directory:** First, make sure you are in the `android` folder in your project directory:

   ```sh
   cd android
   ```

2. **Prepare the test command:** The command to run the tests locally is as follows:

   ```sh
   ./gradlew app:connectedProdDebugAndroidTest -Ptarget=`pwd`/../integration_test/app_test.dart -Pdart-defines=EMAIL_VAR_BASE64,PASSWORD_VAR_BASE64
   ```

   In this command:

   - `./gradlew app:connectedProdDebugAndroidTest` runs the Android instrumentation tests.
   - `-Ptarget` specifies the path to the Dart file containing the integration tests.
   - `-Pdart-defines` allows you to pass in variables to the tests.

3. **Encode the email and password:** Before running the test, you need to base64 encode the email and password you'll be using in the tests.

   For example, let's say we have the following credentials:

   ```
   USER_1_EMAIL=user@example.com
   USER_1_PASSWORD=123
   ```

   You can base64 encode these using a command-line tool like `echo` and `base64`. For instance:

   ```sh
   echo -n "USER_1_EMAIL=user@example.com" | base64
   # Output: VVNFUl8xX0VNQUlMPXVzZXJAZXhhbXBsZS5jb20=

   echo -n "USER_1_PASSWORD=123" | base64
   # Output: VVNFUl8xX1BBU1NXT1JEPTEyMw==
   ```

4. **Run the tests:** Finally, you can run the tests with the following command, replacing `EMAIL_VAR_BASE64` and `PASSWORD_VAR_BASE64` with the base64 encoded values from the previous step:

   ```sh
   ./gradlew app:connectedProdDebugAndroidTest -Ptarget=`pwd`/../integration_test/app_test.dart -Pdart-defines=VVNFUl8xX0VNQUlMPXVzZXJAZXhhbXBsZS5jb20=,VVNFUl8xX1BBU1NXT1JEPTEyMw==
   ```

   _Note:_ If you're a member of the Sharezone team, you can find the already base64 encoded variables in our password manager.

5. **Analyze the test results:** After running the tests, you can view the test results and logs in the command-line output.

For more information about running Android Device Testing for Flutter integration tests, check out the official Flutter documentation:
[Flutter Integration Tests on Android](https://github.com/flutter/flutter/tree/main/packages/integration_test#android-device-testing)

### Web

_Note: The integration tests are not working for the web at the moment because we need to migrate our app to null safety. Otherwise, the build will fail because of this message:_

```
org-dartlang-app:/app_test.dart:27:11: Error: Non-nullable variable 'dependencies' must be assigned before it can be used.
    await dependencies.blocDependencies.auth.signOut();
          ^^^^^^^^^^^^
org-dartlang-app:/app_test.dart:34:30: Error: Non-nullable variable 'dependencies' must be assigned before it can be used.
          beitrittsversuche: dependencies.beitrittsversuche,
                             ^^^^^^^^^^^^
org-dartlang-app:/app_test.dart:35:29: Error: Non-nullable variable 'dependencies' must be assigned before it can be used.
          blocDependencies: dependencies.blocDependencies,
                            ^^^^^^^^^^^^
org-dartlang-app:/app_test.dart:36:28: Error: Non-nullable variable 'dependencies' must be assigned before it can be used.
          dynamicLinkBloc: dependencies.dynamicLinkBloc,
                           ^^^^^^^^^^^^
```

To get started testing in a web browser, download [ChromeDriver](https://chromedriver.chromium.org/downloads).

Launch WebDriver, for example:

```sh
chromedriver --port=4444
```

And then run the following command in a different process:

```sh
fvm flutter test \
  integration_test
  --flavor dev
  -d web-server
```
