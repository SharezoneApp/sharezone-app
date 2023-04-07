// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

enum PackageType { pureDart, flutter }

class Package {
  final Directory location;
  String get path => location.path;
  final String name;
  final PackageType type;
  bool get isFlutterPackage => type == PackageType.flutter;
  bool get isPureDartPackage => type == PackageType.pureDart;
  final bool hasTestDirectory;
  final bool hasGoldenTestsDirectory;

  Package({
    @required this.location,
    @required this.name,
    @required this.type,
    @required this.hasTestDirectory,
    @required this.hasGoldenTestsDirectory,
  });

  factory Package.fromDirectory(Directory directory) {
    final pubspecFile = File(p.join(directory.path, 'pubspec.yaml'));
    final YamlMap pubspecYaml = loadYaml(pubspecFile.readAsStringSync());
    final YamlMap dependencies = pubspecYaml['dependencies'] ?? YamlMap();
    final YamlMap devDependencies =
        pubspecYaml['dev_dependencies'] ?? YamlMap();
    final containsFlutter = dependencies.containsKey('flutter') ||
            devDependencies.containsKey('flutter') ??
        false;
    final name = pubspecYaml['name'] as String;
    final hasTestDirectory =
        Directory(p.join(directory.path, 'test')).existsSync();
    final hasTestGoldensDirectory =
        Directory(p.join(directory.path, 'test_goldens')).existsSync();

    return Package(
      location: directory,
      name: name,
      hasTestDirectory: hasTestDirectory,
      hasGoldenTestsDirectory: hasTestGoldensDirectory,
      type: containsFlutter ? PackageType.flutter : PackageType.pureDart,
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
    throw UnimplementedError();
  }
}
