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

class TestCommand extends Command {
  TestCommand(this.repo) {
    argParser
      ..addVerboseFlag()
      ..addConcurrencyOption(defaultMaxConcurrency: 5)
      ..addPackageTimeoutOption(defaultInMinutes: 10);
  }

  static const maxConcurrentPackagesOptionName = 'max-concurrent-packages';

  final SharezoneRepo repo;

  @override
  final String name = 'test';

  @override
  final String description = 'Runs the Dart tests for all packages.\n\n'
      'This command requires "flutter" to be in your path.';

  @override
  Future<Null> run() async {
    isVerbose = argResults['verbose'] ?? false;

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null wird nachher als "keine Begrenzung" gehandhabt.
        : null;

    final taskRunner = ConcurrentPackageTaskRunner(
      getCurrentDateTime: () => DateTime.now(),
    );

    final res = taskRunner
        .runTaskForPackages(
          packageStream: repo
              .streamPackages()
              .where((package) => package.hasTestDirectory),
          runTask: (package) => package.runTests(),
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
      print('All packages tested successfully!');
      exit(0);
    }
  }
}
