// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

final _androidStages = [
  'stable',
  'alpha',
];

/// The different flavors of the Android app.
final _androidFlavors = [
  'prod',
  'dev',
];

/// The different output types of the Android app.
final _androidOutputType = [
  'appbundle',
  'apk',
];

class BuildAndroidCommand extends Command {
  final SharezoneRepo _repo;

  BuildAndroidCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _androidStages,
        defaultsTo: 'stable',
      )
      ..addOption(
        outputTypeName,
        help: 'The type of output type, either "appbundle" or "apk".',
        allowed: _androidOutputType,
        defaultsTo: 'appbundle',
      )
      ..addOption(
        buildNumberOptionName,
        help: '''An identifier used as an internal version number.
Each build must have a unique identifier to differentiate it from previous builds.
It is used to determine whether one build is more recent than
another, with higher numbers indicating more recent build.
When none is specified, the value from pubspec.yaml is used.''',
      )
      ..addOption(
        flavorOptionName,
        allowed: _androidFlavors,
        help:
            'The flavor to build for. At the moment only "prod" is supported.',
        defaultsTo: 'prod',
      )
      ..addOption(
        googleApplicationCredentialsOptionName,
        help:
            'Google Cloud service account credentials with `JSON` key type to access Google Play Developer API. If not given, the value will be checked from the environment variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`.',
      );
  }

  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const buildNumberOptionName = 'build-number';
  static const googleApplicationCredentialsOptionName = 'credentials';
  static const outputTypeName = 'output-type';

  @override
  String get description =>
      'Build the Sharezone Android app in release mode. Codemagic CLI tools must be installed.';

  @override
  String get name => 'android';

  @override
  Future<void> run() async {
    // Its less work to just print everything right now instead of selectively
    // print and add custom print statements for non-verboes output.
    // One might add non-verbose output in the future but right now this is
    // easier.
    isVerbose = true;

    await _buildApp();
    stdout.writeln('Build finished 🎉 ');
  }

  Future<void> _buildApp() async {
    try {
      final flavor = argResults[flavorOptionName] as String;
      final stage = argResults[releaseStageOptionName] as String;
      final outputType = argResults[outputTypeName] as String;
      final buildNumber = argResults[buildNumberOptionName] as String;
      await runProcessSucessfullyOrThrow(
        'fvm',
        [
          'flutter',
          'build',
          outputType,
          '--target',
          'lib/main_$flavor.dart',
          '--flavor',
          flavor,
          '--release',
          '--dart-define',
          'DEVELOPMENT_STAGE=${stage.toUpperCase()}',
          if (buildNumber != null) ...['--build-number', '$buildNumber'],
        ],
        workingDirectory: _repo.sharezoneFlutterApp.location.path,
      );
    } catch (e) {
      throw Exception('Failed to build Android app: $e');
    }
  }
}
