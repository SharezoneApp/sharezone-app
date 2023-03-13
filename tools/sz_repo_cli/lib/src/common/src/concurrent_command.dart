// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
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

/// Run a task via [runTaskForPackage] for many [Package] concurrently.
abstract class ConcurrentCommand extends Command {
  final SharezoneRepo repo;

  ConcurrentCommand(this.repo) {
    argParser
      ..addVerboseFlag()
      ..addConcurrencyOption(defaultMaxConcurrency: defaultMaxConcurrency)
      ..addPackageTimeoutOption(
          defaultInMinutes: defaultPackageTimeout.inMinutes);
  }

  /// How long the task can run per package before being considered as failed.
  ///
  /// If [runTaskForPackage] takes longer than [defaultPackageTimeout] then the
  /// task for the package that exceeded the timeout will be marked as failing.
  ///
  /// This can be overridden by the user via command line argument.
  Duration get defaultPackageTimeout => Duration(minutes: 10);

  /// Number of packages that are going to be processed concurrently.
  ///
  /// Setting this to <= 0 means that there is no concurrency limit, i.e.
  /// everything will be processed at once.
  ///
  /// This can be overridden by the user via command line argument.
  int get defaultMaxConcurrency => 5;

  /// Used to run setup steps before [runTaskForPackage] is called.
  ///
  /// For example this method might be used to activate a package (`pub global
  /// activate`) that is gonna be used in [runTaskForPackage].
  Future<void> runSetup() async {
    return;
  }

  /// The Task to run for each [Package].
  ///
  /// If e.g. the Command is used to test all packages in the repo then one
  /// might use this method to call `flutter test` for [package].
  Future<void> runTaskForPackage(Package package);

  /// Stream of packages for which [runTaskForPackage] will be called.
  ///
  /// Can be overridden to e.g. add a filter (`.where((package) =>
  /// package.hasTestDirectory`).
  Stream<Package> get packagesToProcess => repo.streamPackages();

  @override
  Future<void> run() async {
    isVerbose = argResults['verbose'] ?? false;
    await runSetup();

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null as interpreted as "no concurrency limit" (everything at once).
        : null;

    final taskRunner = ConcurrentPackageTaskRunner(
      getCurrentDateTime: () => DateTime.now(),
    );

    final res = taskRunner
        .runTaskForPackages(
          packageStream: packagesToProcess,
          runTask: (runTaskForPackage),
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
      print('Task was successfully executed for all packages!');
      exit(0);
    }
  }
}
