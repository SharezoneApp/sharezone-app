// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:args/command_runner.dart';

class PubCommand extends Command {
  @override
  String get description =>
      'Runs a pub command for all files under /lib and maybe /app (depends on command)';

  @override
  String get name => 'pub';
}
