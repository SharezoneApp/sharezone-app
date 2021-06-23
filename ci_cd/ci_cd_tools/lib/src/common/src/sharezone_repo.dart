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
  final Package sharezoneConsole;
  final DartLibraries dartLibraries;
  final CloudFunctions cloudFunctions;
  final Package website;

  SharezoneRepo._({
    @required this.location,
    @required this.sharezoneFlutterApp,
    @required this.dartLibraries,
    @required this.sharezoneCiCdTool,
    @required this.cloudFunctions,
    @required this.website,
    @required this.sharezoneConsole,
  });

  factory SharezoneRepo(Directory rootDirectory) {
    final _root = rootDirectory.path;

    return SharezoneRepo._(
      location: rootDirectory,
      dartLibraries: DartLibraries(
          clientLibariesLocation: Directory(path.join(_root, 'lib')),
          serverLibariesLocation: Directory(path.join(_root, 'backend_dart'))),
      sharezoneFlutterApp: Package.fromDirectory(
        Directory(path.join(_root, 'app')),
      ),
      sharezoneCiCdTool: Package.fromDirectory(Directory(path.join(
        _root,
        'ci_cd',
        'ci_cd_tools',
      ))),
      cloudFunctions: CloudFunctions(Directory(
        path.join(
          _root,
          'infrastructure',
          'google_cloud_platform',
          'firebase',
          'cloud_functions',
        ),
      )),
      website: Package.fromDirectory(Directory(path.join(_root, 'website'))),
      sharezoneConsole: Package.fromDirectory(
        Directory(path.join(_root, 'sharezone_console')),
      ),
    );
  }

  Stream<Package> streamPackages() {
    return dartLibraries.streamPackages().mergeWithValues([
      sharezoneFlutterApp,
      sharezoneCiCdTool,
      website,
    ]);
  }
}

class DartLibraries {
  final Directory clientLibariesLocation;
  final Directory serverLibariesLocation;

  DartLibraries({
    @required this.clientLibariesLocation,
    @required this.serverLibariesLocation,
  });

  Stream<Package> streamPackages() async* {
    final clientLibsStream =
        clientLibariesLocation.list(recursive: true).where(_isDartPackage);
    final serverLibsStream =
        serverLibariesLocation.list(recursive: true).where(_isDartPackage);
    final dartLibsStream = clientLibsStream.mergeWith([serverLibsStream]);
    await for (var entity in dartLibsStream) {
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

class CloudFunctions {
  final Directory location;
  final Directory functionsSubdirectory;

  CloudFunctions(this.location)
      : functionsSubdirectory =
            Directory(path.join(location.path, 'functions'));
}
