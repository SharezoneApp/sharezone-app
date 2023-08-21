// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:args/args.dart';

const _packageTimeoutName = 'package-timeout-minutes';
const maxConcurrentPackagesOptionName = 'max-concurrent-packages';

extension AddPackageTimeout on ArgParser {
  void addVerboseFlag() {
    addFlag(
      'verbose',
      abbr: 'v',
      help: 'if verbose output should be printed (helpful for debugging)',
      negatable: false,
      defaultsTo: false,
    );
  }

  void addPackageTimeoutOption({required int defaultInMinutes}) {
    addOption(
      _packageTimeoutName,
      help:
          'How long the analyze command is allowed to run per package in minutes (if exceeded the package will fail analyzation)',
      defaultsTo: '$defaultInMinutes',
    );
  }

  void addConcurrencyOption({required int defaultMaxConcurrency}) {
    addOption(
      maxConcurrentPackagesOptionName,
      abbr: 'c',
      defaultsTo: '$defaultMaxConcurrency',
      help: '''
How many packages should be processed concurrently at most. Values <= 0 will cause all packages to be processed at once (no concurrency limit). 
Limiting concurrency is helpful for not as powerful machines like e.g. CI-runner.''',
    );
  }
}

extension PackageTimeoutArgResult on ArgResults {
  Duration get packageTimeoutDuration {
    final packageTimeout = this[_packageTimeoutName];
    return Duration(minutes: int.parse(packageTimeout));
  }
}
