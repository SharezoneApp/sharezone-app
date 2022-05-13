# Integration Tests
Unit tests and widget tests are handy for testing individual classes, functions, or widgets. However, they generally don’t test how individual pieces work together as a whole, or capture the performance of an application running on a real device. These tasks are performed with integration tests.

Integration tests are written using the [integration_test](https://github.com/flutter/flutter/tree/master/packages/integration_test) package, provided by the SDK.

## How to run integration tests
In order to run the integration tests, you need to setup a fresh Sharezone account which can be used for the integration tests. This account needs to be linked to an email address and a password.

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


