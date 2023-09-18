// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

enum PackageType { pureDart, flutter }

class Package {
  final Directory location;
  String get path => location.path;
  final String name;

  /// The version of the package.
  ///
  /// Contains the build number if it was specified in the pubspec.yaml.
  ///
  /// Is `null` if no version was specified.
  final String? version;

  final PackageType type;
  bool get isFlutterPackage => type == PackageType.flutter;
  bool get isPureDartPackage => type == PackageType.pureDart;
  final bool hasTestDirectory;
  final bool hasGoldenTestsDirectory;
  final bool hasBuildRunnerDependency;

  Package({
    required this.location,
    required this.name,
    required this.type,
    required this.hasTestDirectory,
    required this.hasGoldenTestsDirectory,
    required this.version,
    required this.hasBuildRunnerDependency,
  });

  factory Package.fromDirectory(Directory directory) {
    final pubspecFile = File(p.join(directory.path, 'pubspec.yaml'));
    final YamlMap pubspecYaml = loadYaml(pubspecFile.readAsStringSync());
    final YamlMap dependencies = pubspecYaml['dependencies'] ?? YamlMap();
    final YamlMap devDependencies =
        pubspecYaml['dev_dependencies'] ?? YamlMap();
    final containsFlutter = dependencies.containsKey('flutter') ||
        devDependencies.containsKey('flutter');
    final name = pubspecYaml['name'] as String?;
    final version = pubspecYaml['version'] as String?;
    if (name == null) {
      throw Exception(
        'Package at "${directory.path}" has no name. Please add a name',
      );
    }
    final hasTestDirectory =
        Directory(p.join(directory.path, 'test')).existsSync();
    final hasTestGoldensDirectory =
        Directory(p.join(directory.path, 'test_goldens')).existsSync();

    final hasBuildRunnerDependency = dependencies.containsKey('build_runner') ||
        devDependencies.containsKey('build_runner');

    return Package(
      location: directory,
      name: name,
      hasTestDirectory: hasTestDirectory,
      hasGoldenTestsDirectory: hasTestGoldensDirectory,
      type: containsFlutter ? PackageType.flutter : PackageType.pureDart,
      version: version,
      hasBuildRunnerDependency: hasBuildRunnerDependency,
    );
  }

  @override
  String toString() {
    return '$runtimeType(name: $name)';
  }
}

extension PackageTypeToReadableString on PackageType {
  String toReadableString() {
    switch (this) {
      case PackageType.flutter:
        return 'Flutter';
      case PackageType.pureDart:
        return 'Dart';
    }
  }
}
