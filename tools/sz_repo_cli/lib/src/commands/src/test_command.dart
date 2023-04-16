// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sz_repo_cli/src/common/common.dart';

import 'pub_get_command.dart';

class TestCommand extends ConcurrentCommand {
  TestCommand(SharezoneRepo repo) : super(repo) {
    argParser.addFlag(
      'exclude-goldens',
      help: 'Run tests without golden tests.',
      defaultsTo: false,
      negatable: false,
    );
    argParser.addFlag(
      'only-goldens',
      help: 'Run only golden tests.',
      defaultsTo: false,
      negatable: false,
    );
  }

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
  Stream<Package> get packagesToProcess {
    if (argResults['only-goldens'] as bool) {
      return repo.streamPackages().where(
            (package) =>
                package.isFlutterPackage && package.hasGoldenTestsDirectory,
          );
    }

    return repo.streamPackages().where((package) => package.hasTestDirectory);
  }

  @override
  Future<void> runTaskForPackage(Package package) {
    return runTests(
      package,
      excludeGoldens: argResults['exclude-goldens'] as bool,
      onlyGoldens: argResults['only-goldens'] as bool,
    );
  }
}

Future<void> runTests(
  Package package, {
  @required bool excludeGoldens,
  @required bool onlyGoldens,
}) {
  if (package.isFlutterPackage) {
    return _runTestsFlutter(
      package,
      excludeGoldens: excludeGoldens,
      onlyGoldens: onlyGoldens,
    );
  } else {
    return _runTestsDart(
      package,
      excludeGoldens: excludeGoldens,
      onlyGoldens: onlyGoldens,
    );
  }
}

Future<void> _runTestsDart(
  Package package, {
  // We can ignore the "excludeGoldens" parameter here because Dart packages
  // don't have golden tests.
  @required bool excludeGoldens,
  @required bool onlyGoldens,
}) async {
  if (onlyGoldens) {
    // Golden tests are only run in the flutter package.
    return;
  }

  await getPackage(package);

  await runProcessSucessfullyOrThrow(
    'fvm',
    ['dart', 'test'],
    workingDirectory: package.path,
  );
}

Future<void> _runTestsFlutter(
  Package package, {
  @required bool excludeGoldens,
  @required bool onlyGoldens,
}) async {
  if (onlyGoldens) {
    if (!package.hasGoldenTestsDirectory) {
      return;
    }

    await runProcessSucessfullyOrThrow(
      'fvm',
      ['flutter', 'test', 'test_goldens'],
      workingDirectory: package.path,
    );
    return;
  }

  // If the package has no golden tests, we need to use the normal test
  // command. Otherwise the throws the Flutter tool throws an error that it
  // couldn't find the "test_goldens" directory.
  if (excludeGoldens || !package.hasGoldenTestsDirectory) {
    await runProcessSucessfullyOrThrow(
      'fvm',
      ['flutter', 'test'],
      workingDirectory: package.path,
    );
    return;
  }

  /// Flutter test lässt automatisch flutter pub get laufen.
  /// Deswegen muss nicht erst noch [getPackages] aufgerufen werden.

  await runProcessSucessfullyOrThrow(
    'fvm',
    [
      'flutter',
      'test',
      // Directory for golden tests.
      'test_goldens',
      // Directory for unit and widget tests.
      'test',
    ],
    workingDirectory: package.path,
  );
}
