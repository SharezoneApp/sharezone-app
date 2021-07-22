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
    final YamlMap dependencies = pubspecYaml['dependencies'];
    final containsFlutter = dependencies?.containsKey('flutter') ?? false;
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
    final process = await Process.start(
      'dart',
      ['pub', 'global', 'run', 'tuneup', 'check', '--fail-on-todos'],
      workingDirectory: location.path,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      // tuneup uses stdout instead of stderr
      final stderrOutput = await process.stdout.toUtf8String();
      throw Exception('Tuneup reported: $stderrOutput');
    }
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
    final process = await Process.start(
      'dart',
      ['pub', 'get'],
      workingDirectory: location.path,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      final stderrOutput = await process.stderr.toUtf8String();
      throw Exception('Could not run flutter pub get: $stderrOutput');
    }
  }

  @override
  Future<void> runTests() async {
    await getPackages();

    final process = await Process.start(
      'dart',
      ['test'],
      workingDirectory: location.path,
    );

    final broadcastStdout = process.stdout.asBroadcastStream();
    if (isVerbose) {
      broadcastStdout.listen(stdout.add);
    }

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      final stdout = await broadcastStdout.toUtf8String();
      throw Exception('Could not run pub run test: $stdout');
    }
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
    final process = await Process.start(
      'flutter',
      ['pub', 'get'],
      workingDirectory: location.path,
      // Else it does not work on Windows (file not found).
      runInShell: true,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      final stderrOutput = await process.stderr.toUtf8String();
      throw Exception('Could not run flutter pub get: $stderrOutput');
    }
  }

  @override
  Future<void> runTests() async {
    /// Flutter test lässt automatisch flutter pub get laufen.
    /// Deswegen muss nicht erst noch [getPackages] aufgerufen werden.

    final process = await Process.start(
      'flutter',
      ['test'],
      workingDirectory: location.path,
    );

    final broadcastStdout = process.stdout.asBroadcastStream();
    if (isVerbose) {
      broadcastStdout.listen(stdout.add);
    }

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      /// Manche Errors werden in stdout, manche auch nur in stderr ausgegeben.
      /// Deswegen geben wir hier erstmal alles aus.
      ///
      /// Aktuelles Verständnis:
      /// Probleme von Tests an sich (Fehlschläge etc.) werden in stdout,
      /// Fehler die das Flutter-Tool selbst überprüft (z.B. Fehler, dass in
      /// einer Test-Directory keine der vorhandenen Dateien mit _test.dart
      /// endet) werden in stderr ausgegeben.
      final stdoutOutput = await broadcastStdout.toUtf8String();
      final stderrOutput = await process.stderr.toUtf8String();
      throw Exception(
          'Could not run flutter test: $stdoutOutput\n$stderrOutput');
    }
  }
}
