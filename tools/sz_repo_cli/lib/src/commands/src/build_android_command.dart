// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/build_utils.dart';

final _androidStages = [
  'stable',
  'beta',
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
  final ProcessRunner processRunner;
  final SharezoneRepo _repo;

  BuildAndroidCommand(this.processRunner, this._repo) {
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
        help: 'The flavor to build for.',
        defaultsTo: 'prod',
      );
  }

  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const buildNumberOptionName = 'build-number';
  static const outputTypeName = 'output-type';

  @override
  String get description => 'Build the Sharezone Android app in release mode.';

  @override
  String get name => 'android';

  @override
  Future<void> run() async {
    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    await _buildApp();
    stdout.writeln('Build finished 🎉 ');
  }

  Future<void> _buildApp() async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      final outputType = argResults![outputTypeName] as String;
      final buildNumber = argResults![buildNumberOptionName] as String?;
      final buildNameWithStage =
          getBuildNameWithStage(_repo.sharezoneFlutterApp, stage);
      await processRunner.runProcess(
        [
          'fvm',
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
          if (buildNumber != null) ...['--build-number', buildNumber],
          if (stage != 'stable') ...['--build-name', buildNameWithStage]
        ],
        workingDirectory: _repo.sharezoneFlutterApp.location,
      );
    } catch (e) {
      throw Exception('Failed to build Android app: $e');
    }
  }
}
