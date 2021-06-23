import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:ci_cd_tools/src/common/common.dart';

class TestCommand extends Command {
  TestCommand(this._repo) {
    argParser
      ..addFlag('exclude-cfs',
          help:
              // used in ci - cf job is seperate from this test command
              'excludes cloud functions from testing (used in ci)',
          negatable: false)
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'if verbose output should be printed (helpful for debugging)',
        negatable: false,
        defaultsTo: false,
      )
      ..addPackageTimeoutOption(defaultInMinutes: 10);
  }

  @override
  final String name = 'test';

  @override
  final String description = 'Runs the Dart tests for all packages.\n\n'
      'This command requires "flutter" to be in your path.';

  final SharezoneRepo _repo;

  Duration packageTimeout;

  @override
  Future<void> run() async {
    packageTimeout = argResults.packageTimeoutDuration;
    isVerbose = argResults['verbose'] ?? false;

    await _testFlutterApp(_repo.sharezoneFlutterApp);
    await _testPackages(_repo.dartLibraries);
    if (!argResults['exclude-cfs']) {
      await _testCloudFunctions(
          _repo.cloudFunctions.functionsSubdirectory.path);
    }

    print('All tests are passing!');
  }

  Future _testFlutterApp(Package flutterApp) async {
    print('Starting flutter app tests...');

    try {
      await flutterApp.runTests().timeout(packageTimeout);
    } catch (e) {
      // Weil der Error ansonsten nicht ausgeprintet wird
      print('$e');
      print('Not all flutter app tests passed!');
      throw ToolExit(1);
    }

    print('All flutter app tests passed!');
  }

  Future<void> _testPackages(DartLibraries dartLibraries) async {
    final failingPackages = <String>[];
    await for (final package in dartLibraries
        .streamPackages()
        .where((package) => package.hasTestDirectory)) {
      final packageName = package.name;

      print(
          'RUNNING $packageName ${[package.type.toReadableString()]} tests...');

      try {
        await package.runTests().timeout(packageTimeout);
        print('COMPLETED $packageName tests');
      } catch (e) {
        print('FAILURE: $e');
        failingPackages.add(packageName);
      }
    }

    print('\n\n');
    if (failingPackages.isNotEmpty) {
      print('Tests for the following packages are failing (see above):');
      failingPackages.forEach((String package) {
        print(' * $package');
      });
      throw ToolExit(1);
    }
    print('All Dart package tests passed!');
  }

  Future<void> _testCloudFunctions(String functionsDirPath) async {
    print('Starting Cloud-Functions tests...');
    final process = await Process.start(
      'npm',
      ['run', 'test'],
      workingDirectory: functionsDirPath,
    ).timeout(packageTimeout);
    if (isVerbose) {
      process.stdout.listen(stdout.add);
    }
    if (await process.exitCode != 0) {
      final output = await process.stdout.toUtf8String();
      print(output);
      print('Not all Cloud Function tests passed!');
      throw ToolExit(1);
    }
    print('All Cloud Function tests passed!');
  }
}
