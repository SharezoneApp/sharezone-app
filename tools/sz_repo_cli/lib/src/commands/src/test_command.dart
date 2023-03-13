// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';

class TestCommand extends ConcurrentCommand {
  TestCommand(SharezoneRepo repo) : super(repo);

  @override
  final String name = 'test';

  @override
  final String description = 'Runs the Dart tests for all packages.\n\n'
      'This command requires "flutter" to be in your path.';

  @override
  int get defaultMaxConcurrency => 5;

  @override
  Duration get defaultPackageTimeout => Duration(minutes: 10);

  @override
  Stream<Package> get packagesToProcess =>
      repo.streamPackages().where((package) => package.hasTestDirectory);

  @override
  Future<void> runTaskForPackage(Package package) {
    return package.runTests();
  }
}
