// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';

class ExecCommand extends ConcurrentCommand {
  ExecCommand(super.processRunner, super.repo) {
    argParser
      ..addFlag('onlyFlutter',
          help: 'Only run the command for Flutter packages.', defaultsTo: false)
      ..addFlag('onlyDart',
          help: 'Only run the command for Dart packages.', defaultsTo: false);
  }

  @override
  final String name = 'exec';

  @override
  final String description = 'Runs a given command for all/multiple packages.';

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 5);

  bool get onlyFlutter => argResults!['onlyFlutter'] as bool;
  bool get onlyDart => argResults!['onlyDart'] as bool;

  @override
  Stream<Package> get packagesToProcess {
    List<bool Function(Package)> testFuncs = [];
    if (onlyDart) testFuncs.add((package) => package.isPureDartPackage);
    if (onlyFlutter) testFuncs.add((package) => package.isFlutterPackage);

    return super.packagesToProcess.where((event) {
      for (var testFunc in testFuncs) {
        if (testFunc(event)) {
          continue;
        } else {
          return false;
        }
      }
      return true;
    });
  }

  @override
  Future<void> runSetup() async {
    if (argResults!.rest.isEmpty) {
      throw ArgumentError(
          'No command given. Please provide a command like this:\n'
          'sz_repo_cli exec --onlyFlutter -- fvm dart fix --apply');
    }
  }

  @override
  Future<void> runTaskForPackage(Package package) async {
    await processRunner.run(
      argResults!.rest,
      workingDirectory: package.location,
    );
  }
}
