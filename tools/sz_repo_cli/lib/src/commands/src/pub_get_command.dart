// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

class PubGetCommand extends ConcurrentCommand {
  PubGetCommand(super.processRunner, super.repo);

  @override
  String get description =>
      'Runs pub get / flutter pub get for all packages under /lib and /app (can be specified)';

  @override
  String get name => 'get';

  @override
  int get defaultMaxConcurrency => 8;

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 5);

  @override
  Future<void> runTaskForPackage(Package package) =>
      getPackage(processRunner, package);
}

Future<void> getPackage(ProcessRunner processRunner, Package package) async {
  if (package.isFlutterPackage) {
    await getPackagesFlutter(processRunner, package);
  } else {
    await getPackagesDart(processRunner, package);
  }
}

Future<void> getPackagesDart(
    ProcessRunner processRunner, Package package) async {
  await processRunner.runProcess(
    ['fvm', 'dart', 'pub', 'get'],
    workingDirectory: package.location,
  );
}

Future<void> getPackagesFlutter(
    ProcessRunner processRunner, Package package) async {
  await processRunner.runProcess(
    ['fvm', 'flutter', 'pub', 'get'],
    workingDirectory: package.location,
  );
}
