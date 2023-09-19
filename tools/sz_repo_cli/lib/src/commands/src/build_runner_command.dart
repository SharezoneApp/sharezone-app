// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:args/command_runner.dart';

class BuildRunnerCommand extends Command {
  @override
  String get description =>
      'Runs "dart run build_runner" for every package that contains build_runner as a dependency.';

  @override
  String get name => 'build_runner';
}
