// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/commands/src/fix_comment_spacing_command.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../common.dart';

enum PackageType { pureDart, flutter }

extension PackageTypeToReadableString on PackageType {
  String toReadableString() {
    switch (this) {
      case PackageType.flutter:
        return 'Flutter';
      case PackageType.pureDart:
        return 'Dart';
    }
    throw UnimplementedError();
  }
}

abstract class Package {
  final Directory location;
  final String name;
  final PackageType type;
  final bool hasTestDirectory;

  Package({
    @required this.location,
    @required this.name,
    @required this.type,
    @required this.hasTestDirectory,
  });

  factory Package.fromDirectory(Directory directory) {
    final pubspecFile = File(path.join(directory.path, 'pubspec.yaml'));
    final YamlMap pubspecYaml = loadYaml(pubspecFile.readAsStringSync());
    final YamlMap dependencies = pubspecYaml['dependencies'] ?? YamlMap();
    final YamlMap devDependencies =
        pubspecYaml['dev_dependencies'] ?? YamlMap();
    final containsFlutter = dependencies.containsKey('flutter') ||
            devDependencies.containsKey('flutter') ??
        false;
    final name = pubspecYaml['name'] as String;
    final hasTestDirectory =
        Directory(path.join(directory.path, 'test')).existsSync();
    final hasTestGoldensDirectory =
        Directory(path.join(directory.path, 'test_goldens')).existsSync();

    return containsFlutter
        ? FlutterPackage(
            location: directory,
            name: name,
            hasTestDirectory: hasTestDirectory,
            hasGoldenTestsDirectory: hasTestGoldensDirectory,
          )
        : DartPackage(
            location: directory,
            name: name,
            hasTestDirectory: hasTestDirectory,
          );
  }

  Future<void> getPackages();

  Future<void> runTests({
    @required bool excludeGoldens,
    @required bool onlyGoldens,
  });

  Future<void> analyzePackage() async {
    await getPackages();
    await _runDartAnalyze();
    await _checkForCommentsWithBadSpacing();
  }

  Future<void> _runDartAnalyze() {
    return runProcessSucessfullyOrThrow(
        'fvm', ['dart', 'analyze', '--fatal-infos', '--fatal-warnings'],
        workingDirectory: location.path);
  }

  Future<void> _checkForCommentsWithBadSpacing() async {
    if (doesPackageIncludeFilesWithBadCommentSpacing(location.path)) {
      throw Exception(
          'Package $name has comments with bad spacing. Fix them by running the `sz fix-comment-spacing` command.');
    }
    return;
  }

  @override
  String toString() {
    return '$runtimeType(name: $name)';
  }
}

class DartPackage extends Package {
  DartPackage({
    @required Directory location,
    @required String name,
    @required bool hasTestDirectory,
  }) : super(
          name: name,
          location: location,
          type: PackageType.pureDart,
          hasTestDirectory: hasTestDirectory,
        );

  @override
  Future<void> getPackages() async {
    await runProcessSucessfullyOrThrow('fvm', ['dart', 'pub', 'get'],
        workingDirectory: location.path);
  }

  @override
  Future<void> runTests({
    // We can ignore the "excludeGoldens" parameter here because Dart packages
    // don't have golden tests.
    @required bool excludeGoldens,
    @required bool onlyGoldens,
  }) async {
    if (onlyGoldens) {
      // Golden tests are only run in the flutter package.
      return;
    }

    await getPackages();

    await runProcessSucessfullyOrThrow(
      'fvm',
      ['dart', 'test'],
      workingDirectory: location.path,
    );
  }
}

class FlutterPackage extends Package {
  /// Whether the package has golden tests.
  ///
  /// We assume that a package has golden tests if it has a `test_goldens`
  /// directory.
  ///
  /// This is only relevant for Flutter packages.
  final bool hasGoldenTestsDirectory;

  FlutterPackage({
    @required Directory location,
    @required String name,
    @required bool hasTestDirectory,
    @required this.hasGoldenTestsDirectory,
  }) : super(
          name: name,
          location: location,
          type: PackageType.flutter,
          hasTestDirectory: hasTestDirectory,
        );

  @override
  Future<void> getPackages() async {
    await runProcessSucessfullyOrThrow(
      'fvm',
      ['flutter', 'pub', 'get'],
      workingDirectory: location.path,
    );
  }

  @override
  Future<void> runTests({
    @required bool excludeGoldens,
    @required bool onlyGoldens,
  }) async {
    if (onlyGoldens) {
      if (!hasGoldenTestsDirectory) {
        return;
      }

      await runProcessSucessfullyOrThrow(
        'fvm',
        ['flutter', 'test', 'test_goldens'],
        workingDirectory: location.path,
      );
      return;
    }

    // If the package has no golden tests, we need to use the normal test
    // command. Otherwise the throws the Flutter tool throws an error that it
    // couldn't find the "test_goldens" directory.
    if (excludeGoldens || !hasGoldenTestsDirectory) {
      await runProcessSucessfullyOrThrow(
        'fvm',
        ['flutter', 'test'],
        workingDirectory: location.path,
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
      workingDirectory: location.path,
    );
  }
}
