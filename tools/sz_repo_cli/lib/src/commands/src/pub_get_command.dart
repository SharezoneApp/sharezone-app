// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:sz_repo_cli/src/common/common.dart';

class PubGetCommand extends Command {
  PubGetCommand(this.repo) {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'if verbose output should be printed (helpful for debugging)',
        negatable: false,
        defaultsTo: false,
      )
      ..addConcurrencyOption(defaultMaxConcurrency: 8)
      ..addPackageTimeoutOption(defaultInMinutes: 5);
  }

  final SharezoneRepo repo;

  @override
  String get description =>
      'Runs pub get / flutter pub get for all packages under /lib and /app (can be specified)';

  @override
  String get name => 'get';

  @override
  Future<void> run() async {
    isVerbose = argResults['verbose'] ?? false;

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null as interpreted as "no conucrrency limit" (everything at once).
        : null;

    final taskRunner = ConcurrentPackageTaskRunner(
      getCurrentDateTime: () => DateTime.now(),
    );

    final res = taskRunner
        .runTaskForPackages(
          packageStream: repo
              .streamPackages()
              .where((package) => package.hasTestDirectory),
          runTask: (package) => package.getPackages(),
          maxNumberOfPackagesBeingProcessedConcurrently:
              maxNumberOfPackagesBeingProcessedConcurrently,
          perPackageTaskTimeout: argResults.packageTimeoutDuration,
        )
        .asBroadcastStream();

    final presenter = PackageTasksStatusPresenter();
    presenter.continuouslyPrintTaskStatusUpdatesToConsole(res);

    final failures = await res.allFailures;

    if (failures.isNotEmpty) {
      print('There were failures. See above for more information.');
      await presenter.printFailedTasksSummary(failures);
      exit(1);
    } else {
      print('Ran "pub get" for all packages successfully!');
      exit(0);
    }
  }
}
