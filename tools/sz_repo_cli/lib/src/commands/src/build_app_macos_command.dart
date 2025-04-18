// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/throw_if_command_is_not_installed.dart';

final _macOsStages = ['stable', 'alpha'];

final _macOsFlavors = ['prod', 'dev'];

class BuildAppMacOsCommand extends CommandBase {
  BuildAppMacOsCommand(super.context) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _macOsStages,
        defaultsTo: 'stable',
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
        allowed: _macOsFlavors,
        help: 'The flavor to build for.',
        defaultsTo: 'prod',
      );
  }

  static const flavorOptionName = 'flavor';
  static const releaseStageOptionName = 'stage';
  static const buildNumberOptionName = 'build-number';

  @override
  String get description => 'Build the Sharezone macOS app in release mode.';

  @override
  String get name => 'macos';

  @override
  Future<void> run() async {
    await throwIfFlutterFireCliIsNotInstalled();

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    await _buildApp();
    stdout.writeln('Build finished 🎉 ');
  }

  Future<void> throwIfFlutterFireCliIsNotInstalled() async {
    await throwIfCommandIsNotInstalled(
      processRunner,
      command: 'flutterfire',
      instructionsToInstall:
          'Docs to install them: https://pub.dev/packages/flutterfire_cli',
    );
  }

  Future<void> _buildApp() async {
    try {
      const flavor = 'prod';
      final stage = argResults![releaseStageOptionName] as String;
      final buildNumber = argResults![buildNumberOptionName] as String?;
      await processRunner.runCommand([
        'flutter',
        'build',
        'macos',
        '--target',
        'lib/main_$flavor.dart',
        '--flavor',
        flavor,
        '--release',
        '--dart-define',
        'DEVELOPMENT_STAGE=${stage.toUpperCase()}',
        if (buildNumber != null) ...['--build-number', buildNumber],
        // For Android we add the stage to the build name (using
        // --build-name), but for iOS we can't do that because Flutter removes
        // the stage from the build name.
        //
        // See:
        //  * https://github.com/flutter/flutter/issues/27589#issuecomment-573121390
        //  * https://github.com/flutter/flutter/issues/115483
      ], workingDirectory: repo.sharezoneFlutterApp.location);
    } catch (e) {
      throw Exception('Failed to build macOS app: $e');
    }
  }
}
