// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';

class PubGetCommand extends ConcurrentCommand {
  PubGetCommand(SharezoneRepo repo) : super(repo);

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
  Future<void> runTaskForPackage(Package package) => getPackage(package);
}

Future<void> getPackage(Package package) async {
  if (package.isFlutterPackage) {
    await getPackagesFlutter(package);
  } else {
    await getPackagesDart(package);
  }
}

Future<void> getPackagesDart(Package package) async {
  await runProcessSuccessfullyOrThrow('fvm', ['dart', 'pub', 'get'],
      workingDirectory: package.path);
}

Future<void> getPackagesFlutter(Package package) async {
  await runProcessSuccessfullyOrThrow(
    'fvm',
    ['flutter', 'pub', 'get'],
    workingDirectory: package.path,
  );
}
