import 'package:flutter_driver/driver_extension.dart';
import 'package:sharezone/main.dart' as app;

Future<void> main() async {
  enableFlutterDriverExtension();
  return app.main(isDriverTest: true);
}
