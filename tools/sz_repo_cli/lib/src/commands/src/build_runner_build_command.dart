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
  BuildRunnerBuild(SharezoneRepo repo) : super(repo) {
    argParser.addFlag(
      'delete-conflicting-outputs',
      help:
          'By default, the user will be prompted to delete any files which already exist but were not known to be generated by this specific build script.',
      aliases: ['d'],
      defaultsTo: false,
      negatable: false,
    );
  }

  @override
  final String name = 'build';

  @override
  final String description =
      'Performs a single build on the specified targets and then exits.';

  @override
  int get defaultMaxConcurrency => 5;

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 10);

  @override
  Stream<Package> get packagesToProcess {
    return repo
        .streamPackages()
        .where((package) => package.hasBuildRunnerDependency);
  }

  @override
  Future<void> runTaskForPackage(Package package) async {
    await runProcessSucessfullyOrThrow(
      'fvm',
      [
        'dart',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
        '${argResults!['delete-conflicting-outputs'] as bool}',
      ],
      workingDirectory: package.path,
    );
  }
}
