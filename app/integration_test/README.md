# Integrations- / E2E-Tests via `integration_test`

Dieser Ordner wird für Tests mit dem [`integration_test`](https://pub.dev/packages/integration_test) Package benutzt.

Das `integration_test`-Package ist die "verbesserte" Version von `flutter_driver` und ermöglicht es einem mit der `widgetTest`-API E2E- bzw. Integrations-Tests zu schreiben, welche auf einem Simulator, echten Gerät oder sogar dem ["Firebase Test Lab"](https://firebase.google.com/docs/test-lab) laufen.

Die Tests, Integration von `integration_test` und eine richtige Pipeline sind momentan noch WIP.    
Es funktionieren momentan schon mal das erfolgreiche Ausführen der Platzhalter Integrations-Tests auf:
* Android (via Flutter-Driver oder `gradlew`)
* Web
* macOS

### Flutter Driver
Mithilfe folgenden Befehls kann der `foo_test.dart` lokal laufen gelassen werden.   
Der Befehl muss aus dem `app`-Ordner heraus laufen gelassen werden (damit die Pfad übereinstimmen).
```
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/foo_test.dart \
  --flavor prod
```

Der `foo_test.dart` **soll extra fehlschlagen** (er beinhaltet einen erfolgreichen und fehlschlagen Test-Fall).

<details>
  <summary>Beispiel-Output (hier wird mehrmals das gleiche ausgeprintet warum auch immer)</summary>
  
```
Running Gradle task 'assembleProdDebug'...                              
Running Gradle task 'assembleProdDebug'... Done                    87,4s
✓ Built build/app/outputs/flutter-apk/app-prod-debug.apk.
Installing build/app/outputs/flutter-apk/app.apk...                 3,7s
I/flutter (10196): Observatory listening on http://127.0.0.1:35209/C0tp8cWHZVU=/
VMServiceFlutterDriver: Connecting to Flutter application at http://127.0.0.1:53350/EDNFZKCFfM0=/
VMServiceFlutterDriver: Isolate found with number: 109424730985447
VMServiceFlutterDriver: Isolate is paused at start.
VMServiceFlutterDriver: Attempting to resume isolate
I/flutter (10196): 00:00 +0: failing test example
VMServiceFlutterDriver: Connected to Flutter application.
I/flutter (10196): (The following exception is now available via WidgetTester.takeException:)
I/flutter (10196): ══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK
╞════════════════════════════════════════════════════
I/flutter (10196): The following TestFailure object was thrown running a test:
I/flutter (10196):   Expected: <5>
I/flutter (10196):   Actual: <4>
I/flutter (10196): 
I/flutter (10196): When the exception was thrown, this was the stack:
I/flutter (10196): #4      main.<anonymous closure>
(file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart:8:5)
I/flutter (10196): #5      testWidgets.<anonymous closure>.<anonymous closure>
(package:flutter_test/src/widget_tester.dart:144:29)
I/flutter (10196): <asynchronous suspension>
[Ausgelassen für weniger Text]
I/flutter (10196): #35     Invoker._onRun.<anonymous closure>
(package:test_api/src/backend/invoker.dart:369:7)
I/flutter (10196): #42     Invoker._onRun (package:test_api/src/backend/invoker.dart:368:11)
I/flutter (10196): #43     LiveTestController.run
(package:test_api/src/backend/live_test_controller.dart:153:11)
I/flutter (10196): (elided 31 frames from dart:async and package:stack_trace)
I/flutter (10196): 
I/flutter (10196): This was caught by the test expectation on the following line:
I/flutter (10196):
file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart line 8
I/flutter (10196): The test description was:
I/flutter (10196):   failing test example
I/flutter (10196):
════════════════════════════════════════════════════════════════════════════════════════════════════
I/flutter (10196): (If WidgetTester.takeException is called, the above exception will be ignored. If it is
not, then the above exception will be dumped when another exception is caught by the framework or when the
test ends, whichever happens first, and then the test will fail due to having not caught or expected the
exception.)
I/flutter (10196): ══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK
╞════════════════════════════════════════════════════
I/flutter (10196): The following TestFailure object was thrown running a test:
I/flutter (10196):   Expected: <5>
I/flutter (10196):   Actual: <4>
I/flutter (10196): 
I/flutter (10196): When the exception was thrown, this was the stack:
I/flutter (10196): #4      main.<anonymous closure>
(file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart:8:5)
I/flutter (10196): #5      testWidgets.<anonymous closure>.<anonymous closure>
(package:flutter_test/src/widget_tester.dart:144:29)
I/flutter (10196): <asynchronous suspension>
[Ausgelassen für weniger Text]
I/flutter (10196): #35     Invoker._onRun.<anonymous closure>
(package:test_api/src/backend/invoker.dart:369:7)
I/flutter (10196): #42     Invoker._onRun (package:test_api/src/backend/invoker.dart:368:11)
I/flutter (10196): #43     LiveTestController.run
(package:test_api/src/backend/live_test_controller.dart:153:11)
I/flutter (10196): (elided 31 frames from dart:async and package:stack_trace)
I/flutter (10196): 
I/flutter (10196): This was caught by the test expectation on the following line:
I/flutter (10196):
file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart line 8
I/flutter (10196): The test description was:
I/flutter (10196):   failing test example
I/flutter (10196):
════════════════════════════════════════════════════════════════════════════════════════════════════
I/flutter (10196): 00:00 +0: failing test example [E]
I/flutter (10196):   Test failed. See exception logs above.
I/flutter (10196):   The test description was: failing test example
I/flutter (10196):   
I/flutter (10196): 00:00 +0 -1: succeeding test example
Failure Details:
Failure in method: failing test example
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞═════════════════
The following TestFailure object was thrown running a test:
  Expected: <5>
  Actual: <4>

When the exception was thrown, this was the stack:
#4      main.<anonymous closure> (file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart:8:5)
#5      testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:144:29)
[Ausgelassen für weniger Text]
#35     Invoker._onRun.<anonymous closure> (package:test_api/src/backend/invoker.dart:369:7)
#42     Invoker._onRun (package:test_api/src/backend/invoker.dart:368:11)
#43     LiveTestController.run (package:test_api/src/backend/live_test_controller.dart:153:11)
(elided 31 frames from dart:async and package:stack_trace)

This was caught by the test expectation on the following line:
  file:///Users/jonassharezone/development/projects/sharezone-app/app/integration_test/foo_test.dart line 8
The test description was:
  failing test example
═════════════════════════════════════════════════════════════════

end of failure 1



Stopping application instance.
Driver tests failed: 1
```
</details>

### Web
Der Test kann wie folgt auf dem Web gelaufen lassen werden:
1. Falls nicht bereits vorhanden `chromedriver` installieren. (z.B. per `brew install chromedriver`)
2. `chromedriver --port=4444` ausführen und einen Server starten
3. In einem anderem Terminal aus dem `app`-Ordner den unten stehenden Flutter-Befehl ausführen
```
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/foo_test.dart \
  -d web-server
```

### Android Device Testing
Disclaimer: Ich (Jonas) weiß noch nicht, was der Unterschied zwischen einem solchen Test und einem Flutter-Driver Test auf einem Android-Gerät ist.

Unter `app/android` folgenden Befehl ausführen:
```
./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../integration_test/foo_test.dart
```

Beispiel-Output:
```
> Task :app:connectedDevDebugAndroidTest FAILED

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:connectedDevDebugAndroidTest'.
> There were failing tests. See the report at: file:///Users/jonassharezone/development/projects/sharezone-app/app/build/app/reports/androidTests/connected/flavors/DEV/index.html

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.3/userguide/command_line_interface.html#sec:command_line_warnings

BUILD FAILED in 2m 13s
963 actionable tasks: 961 executed, 2 up-to-date
```

### Firebase Test Lab 
Noch nicht getestet.

### iOS Device Testing
**Nicht funktionell:** Für das iOS Device Testing wurde das Target "RunnerTests" unter XCode hinzugefügt. Allerdings schlägt das builden immer noch durch folgenden Fehler fehl: `'IntegrationTest/IntegrationTestIosTest.h' file not found`  
Siehe Ticket: https://github.com/flutter/flutter/issues/72876

Unter `app/ios` folgenden Befehl ausführen (flavor anpassen):
```
flutter build ios --flavor prod integration_test/foo_test.dart --simulator 
```

Nächster Schritt noch unklar
```
???
```

### macOS

Mit folgendem Befehl lässt sich die App für macOS builden und die momentanen Platzhalter-Tests laufen (und richtigerweise fehlschlagen):
```
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/foo_test.dart  \
  -d macos
```
 

Es erscheint allerdings diese Warnung:
```
flutter: Warning: integration_test test plugin was not detected.
```

Was das genau bedeutet ist mir momentan unklar. Es kann sein, dass so richtige App- bzw. Widget-Tests doch nicht funktionieren. Das ist allerdings nur eine Vermutung.