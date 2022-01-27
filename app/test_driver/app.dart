// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_driver/driver_extension.dart';
import 'package:sharezone/main.dart' as app;

Future<void> main() async {
  enableFlutterDriverExtension();
  return app.main(isDriverTest: true);
}
