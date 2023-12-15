// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';

class BuildRunnerBuild extends ConcurrentCommand {
  BuildRunnerBuild(super.context);

  @override
  final String name = 'build';

  @override
  final String description =
      'Performs a single build on the specified targets and then exits. Uses the "--delete-conflicting-outputs" flag';

  @override
  int get defaultMaxConcurrency => 5;

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 10);

  @override
  Stream<Package> get packagesToProcess {
    return super
        .packagesToProcess
        .where((package) => package.hasBuildRunnerDependency);
  }

  @override
  Future<void> runTaskForPackage(Package package) async {
    await processRunner.runDartCommand(
      [
        'run',
        'build_runner',
        'build',
        // We use the "--delete-conflicting-outputs" flag, because we want to
        // delete the conflicting outputs.
        //
        // Normally, the Dart CLI shows three options when there is a conflict:
        // delete (1), cancel build (2) or list conflicts (3). But since we
        // don't show the output of the `dart run build_runner` command, the
        // user has no way to choose between these options.
        //
        // Therefore, we hard code it to delete the conflicting outputs.
        '--delete-conflicting-outputs',
      ],
      workingDirectory: package.location,
    );
  }
}
