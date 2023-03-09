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

class AnalyzeCommand extends Command {
  AnalyzeCommand(this.repo) {
    argParser
      ..addVerboseFlag()
      ..addConcurrencyOption(defaultMaxConcurrency: 5)
      ..addPackageTimeoutOption(defaultInMinutes: 7);
  }

  static const maxConcurrentPackagesOptionName = 'max-concurrent-packages';

  final SharezoneRepo repo;

  @override
  final String name = 'analyze';

  @override
  final String description = 'Analyzes all packages using package:tuneup.\n\n'
      'This command requires "pub" and "flutter" to be in your path.';

  @override
  Future<Null> run() async {
    isVerbose = argResults['verbose'] ?? false;

    print('Activating tuneup package...');
    await runProcessSucessfullyOrThrow(
        'fvm', ['dart', 'pub', 'global', 'activate', 'tuneup'],
        workingDirectory: repo.sharezoneFlutterApp.location.path);

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
          packageStream: repo.streamPackages(),
          runTask: ((package) => package.analyzePackage()),
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
      print('All packages analyzed successfully!');
      exit(0);
    }
  }
}
