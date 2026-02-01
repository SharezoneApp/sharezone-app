// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:file/file.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

class PubGetCommand extends ConcurrentCommand {
  PubGetCommand(super.context);

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
  if (!shouldRunPubGet(package)) {
    if (isVerbose) {
      stdout.writeln(
        'Skipping pub get for ${package.name} (package config up to date).',
      );
    }
    return;
  }

  if (package.isFlutterPackage) {
    await getPackagesFlutter(processRunner, package);
  } else {
    await getPackagesDart(processRunner, package);
  }
}

bool shouldRunPubGet(Package package) {
  final pubspec = package.location.childFile('pubspec.yaml');
  if (!pubspec.existsSync()) {
    return true;
  }

  final pubspecLock = package.location.childFile('pubspec.lock');
  final pubspecOverrides = package.location.childFile('pubspec_overrides.yaml');
  final packageConfig = package.location
      .childDirectory('.dart_tool')
      .childFile('package_config.json');
  final legacyPackages = package.location.childFile('.packages');

  if (!packageConfig.existsSync() && !legacyPackages.existsSync()) {
    return true;
  }

  final latestInputChange = _latestModified([
    pubspec,
    pubspecLock,
    pubspecOverrides,
  ]);
  final latestConfigChange = _latestModified([packageConfig, legacyPackages]);

  if (latestInputChange == null || latestConfigChange == null) {
    return true;
  }

  return latestInputChange.isAfter(latestConfigChange);
}

DateTime? _latestModified(Iterable<File> files) {
  DateTime? latest;
  for (final file in files) {
    if (!file.existsSync()) {
      continue;
    }
    final modified = file.lastModifiedSync();
    if (latest == null || modified.isAfter(latest)) {
      latest = modified;
    }
  }
  return latest;
}

Future<void> getPackagesDart(
  ProcessRunner processRunner,
  Package package,
) async {
  await processRunner.runCommand([
    'dart',
    'pub',
    'get',
  ], workingDirectory: package.location);
}

Future<void> getPackagesFlutter(
  ProcessRunner processRunner,
  Package package,
) async {
  await processRunner.runCommand([
    'flutter',
    'pub',
    'get',
  ], workingDirectory: package.location);
}
