import 'dart:io';

import 'package:sz_repo_cli/src/commands/src/fix_comment_spacing_command.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../common.dart';

Future<void> _run(
  String executable,
  List<String> arguments, {
  String workingDirectory,
  Map<String, String> environment,
  // ignore: unused_element
  bool includeParentEnvironment,
  bool runInShell,
  ProcessStartMode mode = ProcessStartMode.normal,
}) async {
  final displayableCommand = '$executable ${arguments.join(' ')}';
  if (isVerbose) print('Starting $displayableCommand...');

  final process = await Process.start(executable, arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: true,
      runInShell: true,
      mode: mode);

  // Somehow (at least on Windows but I think also on other platforms)
  // `await process.exitCode` below doesn't complete if we don't listen to
  // stdout or stderr of the process?!?!?!
  // I don't know why and it's really confusing.
  final broadcastStdout = process.stdout.asBroadcastStream();
  final broadcastStderr = process.stderr.asBroadcastStream();

  // Stream live output if desired
  broadcastStdout.listen(isVerbose ? stdout.add : (_) {});
  broadcastStderr.listen(isVerbose ? stderr.add : (_) {});

  // Buffer output to print if process has error
  // We don't listen until a Stream completes because for some __ reason `dart
  // pub get` doesn't close stderr stream when encountering an error (means that
  // we would wait for ever).
  final stdoutBuffer = StringBuffer();
  broadcastStdout.toUtf8().listen(stdoutBuffer.write);
  final stderrBuffer = StringBuffer();
  broadcastStderr.toUtf8().listen(stderrBuffer.write);

  if (isVerbose) print('Waiting for exit code...');
  final exitCode = await process.exitCode;
  if (isVerbose) print('Got exit code $exitCode...');

  if (exitCode != 0) {
    final stdoutOutput = stdoutBuffer.toString();
    final stderrOutput = stderrBuffer.toString();

    throw Exception(
        'Could not run $displayableCommand (exit code $exitCode): $stderrOutput\n\n stdout:$stdoutOutput');
  }
}

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
    await _run(
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
    await _run('dart', ['pub', 'get'],
        workingDirectory: location.path, runInShell: true);
  }

  @override
  Future<void> runTests() async {
    await getPackages();

    await _run(
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
    await _run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: location.path,
      // Else it does not work on Windows (file not found).
      runInShell: true,
    );
  }

  @override
  Future<void> runTests() async {
    /// Flutter test lässt automatisch flutter pub get laufen.
    /// Deswegen muss nicht erst noch [getPackages] aufgerufen werden.

    await _run(
      'flutter',
      ['test'],
      workingDirectory: location.path,
      runInShell: true,
    );
  }
}
