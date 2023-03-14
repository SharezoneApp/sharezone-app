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


