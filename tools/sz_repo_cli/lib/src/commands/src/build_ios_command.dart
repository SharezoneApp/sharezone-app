// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:args/command_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

final _iosStages = [
  'stable',
  'alpha',
];

/// The different flavors of the Android app.
final _iosFlavors = [
  'prod',
  'dev',
];

class BuildIosCommand extends Command {
  final SharezoneRepo _repo;

  BuildIosCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _iosStages,
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
        exportOptionsPlistName,
        help:
            'Export an IPA with these options. See "xcodebuild -h" for available exportOptionsPlist keys.',
      )
      ..addOption(
        flavorOptionName,
        allowed: _iosFlavors,
        help: 'The flavor to build for.',
        defaultsTo: 'prod',
      );
  }

  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const buildNumberOptionName = 'build-number';
  static const exportOptionsPlistName = 'export-options-plist';

  @override
  String get description => 'Build the Sharezone iOS app in release mode.';

  @override
  String get name => 'ios';

  @override
  Future<void> run() async {
    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    await _buildApp();
    print('Build finished 🎉 ');
  }

  Future<void> _buildApp() async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      final buildNumber = argResults![buildNumberOptionName] as String?;
      final exportOptionsPlist = argResults![exportOptionsPlistName] as String?;
      await runProcessSucessfullyOrThrow(
        'fvm',
        [
          'flutter',
          'build',
          'ipa',
          '--target',
          'lib/main_$flavor.dart',
          '--flavor',
          flavor,
          '--release',
          '--dart-define',
          'DEVELOPMENT_STAGE=${stage.toUpperCase()}',
          if (buildNumber != null) ...['--build-number', buildNumber],
          if (exportOptionsPlist != null) ...[
            '--export-options-plist',
            exportOptionsPlist
          ],
        ],
        workingDirectory: _repo.sharezoneFlutterApp.location.path,
      );
    } catch (e) {
      throw Exception('Failed to build iOS app: $e');
    }
  }
}
