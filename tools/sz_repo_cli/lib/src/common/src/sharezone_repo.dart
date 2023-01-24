// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'merge_with_value_stream_extension.dart';
import 'package:path/path.dart' as path;

import 'package.dart';

class SharezoneRepo {
  final Directory location;
  final Package sharezoneFlutterApp;
  final Package sharezoneCiCdTool;
  final DartLibraries dartLibraries;

  File get commandsSourceOfTruthYamlFile => File(path.join(location.path, 'bin',
      'source_of_truth', 'commands_source_of_truth.yaml'));

  SharezoneRepo._({
    @required this.location,
    @required this.sharezoneFlutterApp,
    @required this.dartLibraries,
    @required this.sharezoneCiCdTool,
  });

  factory SharezoneRepo(Directory rootDirectory) {
    final _root = rootDirectory.path;

    return SharezoneRepo._(
      location: rootDirectory,
      dartLibraries: DartLibraries(
        clientLibariesLocation: Directory(path.join(_root, 'lib')),
      ),
      sharezoneFlutterApp: Package.fromDirectory(
        Directory(path.join(_root, 'app')),
      ),
      sharezoneCiCdTool: Package.fromDirectory(Directory(path.join(
        _root,
        'tools',
        'sz_repo_cli',
      ))),
    );
  }

  Stream<Package> streamPackages() {
    return dartLibraries.streamPackages().endWithMany([
      sharezoneFlutterApp,
      sharezoneCiCdTool,
    ]);
  }
}

class DartLibraries {
  final Directory clientLibariesLocation;

  DartLibraries({
    @required this.clientLibariesLocation,
  });

  Stream<Package> streamPackages() async* {
    final clientLibsStream =
        clientLibariesLocation.list(recursive: true).where(_isDartPackage);
    await for (var entity in clientLibsStream) {
      if (entity is Directory) {
        try {
          yield Package.fromDirectory(entity);
        } catch (e) {
          print('Could not create package from $entity.');
        }
      }
    }
  }

  /// Returns whether the specified entity is a directory containing a
  /// `pubspec.yaml` file.
  bool _isDartPackage(FileSystemEntity entity) {
    return entity is Directory &&
        File(path.join(entity.path, 'pubspec.yaml')).existsSync();
  }
}
