// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

import 'package.dart';

class SharezoneRepo {
  final Directory location;
  final Package sharezoneFlutterApp;
  final Package sharezoneCiCdTool;
  final Package sharezoneWebsite;
  final DartLibraries dartLibraries;

  File get commandsSourceOfTruthYamlFile => File(path.join(location.path, 'bin',
      'source_of_truth', 'commands_source_of_truth.yaml'));

  SharezoneRepo._({
    required this.location,
    required this.sharezoneFlutterApp,
    required this.dartLibraries,
    required this.sharezoneCiCdTool,
    required this.sharezoneWebsite,
  });

  factory SharezoneRepo(Directory rootDirectory) {
    final root = rootDirectory.path;

    return SharezoneRepo._(
      location: rootDirectory,
      dartLibraries: DartLibraries(
        clientLibariesLocation: Directory(path.join(root, 'lib')),
      ),
      sharezoneFlutterApp: Package.fromDirectory(
        Directory(path.join(root, 'app')),
      ),
      sharezoneCiCdTool: Package.fromDirectory(Directory(path.join(
        root,
        'tools',
        'sz_repo_cli',
      ))),
      sharezoneWebsite: Package.fromDirectory(
        Directory(path.join(root, 'website')),
      ),
    );
  }

  Stream<Package> streamPackages() {
    // This stream is often used to start tasks for all packages (like testing
    // or analyzing every Dart package), including our Sharezone app package.
    //
    // The order in which the packages are output by this stream will most
    // likely be the order in which tasks are started for these packages. E.g.
    // if we put the Sharezone app package at the start of the stream then it
    // will be the first package to be tested.
    //
    // There is a tradeoff between starting with the Sharezone app or putting it
    // at the end of the stream, since its very big (many widget tests, many
    // files) and a task for this package takes way longer than the same task
    // for the other packages (at least at time of writing this).
    //
    // In GitHub Actions the Sharezone app task was often the first to start and
    // the last to end (when we were starting with it).
    //
    // We assume that we run tasks concurrently for several packages (e.g. test
    // 5 packages at the same time).
    //
    // If we start with the task for the Sharezone app then it will run
    // continously while we start and finish the same tasks for the smaller
    // other Dart packages (since they will finish faster).
    //
    // Starting with the Sharezone app will cause the overall goal (e.g. testing
    // all Dart packages) to be a bit faster from what we measured (might be
    // different in the future or per machine) but on slow machines like CI
    // runner we might hit the package task timeout for the Sharezone app
    // package since the single task will takes longer.
    //
    // So either we increase the package task timeout or we end with the
    // Sharezone app task.
    //
    // For now I (Jonas) decided to output the Sharezone package at the end so
    // that we can keep our per package task timeout low (so we know right away
    // if something takes too long).
    //
    // This might be changed in the future. As always - just measure and see for
    // yourselves.
    return dartLibraries.streamPackages().endWithMany([
      sharezoneFlutterApp,
      sharezoneCiCdTool,
      sharezoneWebsite,
    ]);
  }
}

class DartLibraries {
  final Directory clientLibariesLocation;

  DartLibraries({
    required this.clientLibariesLocation,
  });

  Stream<Package> streamPackages() async* {
    final clientLibsStream =
        clientLibariesLocation.list(recursive: true).where(_isDartPackage);
    await for (var entity in clientLibsStream) {
      if (entity is Directory) {
        try {
          yield Package.fromDirectory(entity);
        } catch (e) {
          stderr.writeln('Could not create package from $entity.');
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
