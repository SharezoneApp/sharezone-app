// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/util/flavor.dart';

Future main({
  @required Flavor flavor,
}) async {
  return runFlutterApp(flavor: flavor);
}
