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

    return containsFlutter
        ? FlutterPackage(
            location: directory,
            name: name,
            hasTestDirectory: hasTestDirectory,
          )
        : DartPackage(
            location: directory,
            name: name,
            hasTestDirectory: hasTestDirectory,
          );
  }

  Future<void> getPackages();

  Future<void> runTests();

  Future<void> analyzePackage() async {
    await getPackages();
    await _runTuneup();
    await _checkForCommentsWithBadSpacing();
  }

  Future<void> _runTuneup() async {
    await runProcessSucessfullyOrThrow(
      'dart',
      ['pub', 'global', 'run', 'tuneup', 'check', '--fail-on-todos'],
      workingDirectory: location.path,
    );
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
    await runProcessSucessfullyOrThrow('dart', ['pub', 'get'],
        workingDirectory: location.path);
  }

  @override
  Future<void> runTests() async {
    await getPackages();

    await runProcessSucessfullyOrThrow(
      'dart',
      ['test'],
      workingDirectory: location.path,
    );
  }
}

class FlutterPackage extends Package {
  FlutterPackage({
    @required Directory location,
    @required String name,
    @required bool hasTestDirectory,
  }) : super(
          name: name,
          location: location,
          type: PackageType.flutter,
          hasTestDirectory: hasTestDirectory,
        );

  @override
  Future<void> getPackages() async {
    await runProcessSucessfullyOrThrow(
      'flutter',
      ['pub', 'get'],
      workingDirectory: location.path,
    );
  }

  @override
  Future<void> runTests() async {
    /// Flutter test lässt automatisch flutter pub get laufen.
    /// Deswegen muss nicht erst noch [getPackages] aufgerufen werden.

    await runProcessSucessfullyOrThrow(
      'flutter',
      ['test'],
      workingDirectory: location.path,
    );
  }
}
