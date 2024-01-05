// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/build_utils.dart';

final _webStages = [
  'stable',
  'beta',
  'alpha',
];

/// The different flavors of the Web app.
final _webFlavors = [
  'prod',
  'dev',
];

class BuildWebCommand extends CommandBase {
  BuildWebCommand(super.context) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _webStages,
        defaultsTo: 'stable',
      )
      ..addOption(
        flavorOptionName,
        allowed: _webFlavors,
        help: 'The flavor to build for.',
        defaultsTo: 'prod',
      );
  }

  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';

  @override
  String get description => 'Build the Sharezone web app in release mode.';

  @override
  String get name => 'web';

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
      final buildNameWithStage =
          getBuildNameWithStage(repo.sharezoneFlutterApp, stage);
      await processRunner.runCommand(
        [
          'fvm',
          'flutter',
          'build',
          'web',
          '--target',
          'lib/main_$flavor.dart',
          '--release',
          '--web-renderer',
          'canvaskit',
          '--dart-define',
          'DEVELOPMENT_STAGE=${stage.toUpperCase()}',
          if (stage != 'stable') ...['--build-name', buildNameWithStage]
        ],
        workingDirectory: repo.sharezoneFlutterApp.location,
      );
    } catch (e) {
      throw Exception('Failed to build web app: $e');
    }
  }
}
