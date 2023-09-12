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
  'beta',
];

/// The different flavors of the Android app that support deployment.
final _androidFlavors = [
  'prod',
];

class DeployAndroidCommand extends Command {
  final SharezoneRepo _repo;

  DeployAndroidCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _androidStages,
        help:
            'The stage to deploy to. The "stable" and "beta" stage is used for '
            'Play Store releases.',
        defaultsTo: 'stable',
      )
      ..addOption(
        whatsNewOptionName,
        help:
            "Release notes either for the Play Store submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 500 characters when you publish the Play Store. Example usage: --whats-new 'Bug fixes and performance improvements.'",
      )
      ..addOption(
        flavorOptionName,
        allowed: _androidFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      );
  }

  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const whatsNewOptionName = 'whats-new';

  static const _changelogDirectory =
      'android/fastlane/metadata/android/de-DE/changelogs';
  static const _defaultChangelogFileName = 'default.txt';
  static const _changelogFilePath =
      '$_changelogDirectory/$_defaultChangelogFileName';

  @override
  String get description =>
      'Deploys the Sharezone Android app to the Play Store. Automatically bumps the build number and builds the app. Codemagic CLI tools & Fastlane are required.';

  @override
  String get name => 'android';

  @override
  Future<void> run() async {
    _throwIfFlavorIsNotSupportForDeployment();
    _checkIfGooglePlayCredentialsAreValid();

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    final buildNumber = await _getNextBuildNumber();
    await _buildApp(buildNumber: buildNumber);
    await _publish();

    stdout.writeln('Deployment finished 🎉 ');
  }

  void _throwIfFlavorIsNotSupportForDeployment() {
    final flavor = argResults![flavorOptionName] as String;
    if (flavor != 'prod') {
      throw Exception(
        'Only the "prod" flavor is supported for Android deployment.',
      );
    }
  }

  /// Checks if Fastlane can establish a connection to Google Play.
  ///
  /// See https://docs.fastlane.tools/actions/validate_play_store_json_key
  Future<void> _checkIfGooglePlayCredentialsAreValid() async {
    await runProcessSucessfullyOrThrow(
      'fastlane',
      ['run', 'validate_play_store_json_key'],
      workingDirectory: '${_repo.sharezoneFlutterApp.location.path}/android',
    );
  }

  Future<int> _getNextBuildNumber() async {
    final latestBuildNumber = await _getLatestBuildNumberFromGooglePlay();
    final nextBuildNumber = latestBuildNumber + 1;
    stdout.writeln('Next build number: $nextBuildNumber');
    return nextBuildNumber;
  }

  /// Returns the latest build number from Google Play across all tracks.
  Future<int> _getLatestBuildNumberFromGooglePlay() async {
    try {
      const packageName = 'de.codingbrain.sharezone';
      final result = await runProcess(
        'google-play',
        [
          'get-latest-build-number',
          '--package-name',
          packageName,
        ],
      );
      return int.parse(result.stdout);
    } catch (e) {
      throw Exception('Failed to get latest build number from Google Play: $e');
    }
  }

  Future<void> _buildApp({required int buildNumber}) async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      await runProcessSucessfullyOrThrow(
        'fvm',
        [
          'dart',
          'run',
          'sz_repo_cli',
          'build',
          'android',
          '--flavor',
          flavor,
          '--stage',
          stage,
          '--build-number',
          '$buildNumber',
        ],
        workingDirectory: _repo.sharezoneCiCdTool.path,
      );
    } catch (e) {
      throw Exception('Failed to build Android app: $e');
    }
  }

  Future<void> _publish() async {
    try {
      await _setChangelog();

      final track = _getGooglePlayTrackFromStage();
      await _uploadToGooglePlay(track: track);
    } finally {
      await _removeChangelogFile();
    }
  }

  Future<void> _setChangelog() async {
    final whatsNew = argResults![whatsNewOptionName] as String?;
    if (whatsNew == null) {
      stdout.writeln('No changelog given. Skipping.');
      return;
    }

    final appPath = _repo.sharezoneFlutterApp.location.path;
    final changelogFile = File('$appPath/$_changelogFilePath');

    // Create folder, if it doesn't exist.
    await changelogFile.parent.create(recursive: true);

    // Write changelog into file. Fastlane will pick it up automatically.
    //
    // See: https://docs.fastlane.tools/actions/upload_to_play_store/#changelogs-whats-new
    await changelogFile.writeAsString(whatsNew);
  }

  String _getGooglePlayTrackFromStage() {
    final stage = argResults![releaseStageOptionName] as String;
    switch (stage) {
      case 'stable':
        return 'production';
      case 'beta':
        return 'beta';
      default:
        throw Exception('Unknown stage: $stage');
    }
  }

  Future<void> _uploadToGooglePlay({
    required String track,
  }) async {
    await runProcess(
      'fastlane',
      ['deploy'],
      workingDirectory: '${_repo.sharezoneFlutterApp.location.path}/android',
      environment: {
        'TRACK': track,
      },
    );
  }

  Future<void> _removeChangelogFile() async {
    final changelogFile = File(_changelogFilePath);
    if (await changelogFile.exists()) {
      await changelogFile.delete();
    }
  }
}
