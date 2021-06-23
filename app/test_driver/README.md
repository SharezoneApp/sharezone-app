# Flutter_Driver-Tests

Die in dem Ordner vorhandenen Tests können für Android mit dem Befehl:
```
flutter drive --target=test_driver/app.dart --flavor dev
```
laufen gelassen werden (working directory ist dem Beispiel `sharezone-app/app`). 

Momentan kann `--flavor prod` sowie `--flavor dev` genutzt werden.

Die Tests wurden bisher nur auf einem lokal laufenden Android Emulator getestet und funktionieren auf Web/Desktop etc wahrscheinlich noch nicht.

### `kIsDriverTest`
Die globale Variable `kIsDriverTest` kann genutzt werden um im App-Code zu gucken, ob dieser über einen Driver-Test ausgeführt wird.   

Sie wird beispielsweise genutzt, um den iOS-Notifikations-Erlaubnisdialog zu deaktivieret, da dieser Dialog ein iOS-natives Element ist und  Driver nicht mit solchen nativen Elementen interagieren kann (also nicht "Erlauben" drücken kann).

Beispiel: 
```dart
if (!kIsDriverTest) _requestIOSPermission(context);
```

Die globale Variable `kIsDriverTest` wird via `isDriverTest`-Parameter der `main`-Methode (`lib/main.dart`) übergeben.  

### `ValueKey`s

Bei vielen Widgetes müssen für einen Driver-Test `ValueKey`s hinugefügt werden. Diese werden genutzt um im Test ein spezielles Widget via `find.byValueKey` auszuwählen.  

Bei Flutter-Driver Tests gibt es leider nicht so viele `Finder`, wie in `flutter:test`, weshalb Widgets oft nur über diese `ValueKey`s gefunden werden können.  

Die Convention, für `ValueKey`s, welche primär von Driver-Tests genutzt werden, ist den Name/Inhalt mit Bindestrichen kleingeschrieben mit einem angehangenen "-E2E" (`ValueKey('key-name-E2E')`) zu schreiben.  

Beispiele:  
* `ValueKey('drawer-open-icon-E2E');`
* `ValueKey('write-message-text-field-E2E');`
* `ValueKey('sign-out-button-E2E');`


Diese Convention soll darauf hinweisen, dass ein solcher `ValueKey` nicht einfach umgenannt werden sollte.  


### Weitere Infos

* [Flutter Cookbook - An introduction to integration testing](https://flutter.dev/docs/cookbook/testing/integration/introduction)
