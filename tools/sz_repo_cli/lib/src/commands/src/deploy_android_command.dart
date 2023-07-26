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

/// The different flavors of the Anroid app that support deployment.
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
        allowed: _iosStages,
        help:
            'The stage to deploy to. The "stable" stage is used for Play Store '
            'releases, the "alpha" stage is used for Firebase Distribtion '
            'releases.',
        defaultsTo: 'stable',
      )
      ..addOption(
        googleApplicationCredentialsOptionName,
        help:
            'Google Cloud service account credentials with `JSON` key type to access Google Play Developer API. If not given, the value will be checked from the environment variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`.',
      )
      ..addOption(
        whatsNewOptionName,
        help:
            "Release notes either for the Play Store or Firebase Distribtion submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 500 characters when you publish the Play Store. Example usage: --whats-new 'Bug fixes and performance improvements.'",
      )
      ..addOption(
        flavorOptionName,
        allowed: _androidFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      );
  }

  static const googleApplicationCredentialsOptionName = 'credentials';
  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const whatsNewOptionName = 'whats-new';

  @override
  String get description =>
      'Deploys the Sharezone Android app to the Play Store or Firebase Distribiton. Automatically bumps the build number and builds the app. Codemagic CLI tools & Fastlane are required.';

  @override
  String get name => 'android';

  @override
  Future<void> run() async {
    _throwIfFlavorIsNotSupportForDeployment();

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    final buildNumber = await _getNextBuildNumber();
    await _buildApp(buildNumber: buildNumber);
    await _publish();

    print('Deployment finished 🎉 ');
  }

  void _throwIfFlavorIsNotSupportForDeployment() {
    final flavor = argResults![flavorOptionName] as String;
    if (flavor != 'prod') {
      throw Exception(
        'Only the "prod" flavor is supported for Android deployment.',
      );
    }
  }

  Future<void> _publish() async {
    final whatsNew = argResults![whatsNewOptionName] as String?;
    final stage = argResults![releaseStageOptionName] as String;

    final isStable = stage == 'stable';
    await runProcess('fastlane', ['deploy'],
        workingDirectory: '${_repo.sharezoneFlutterApp.location.path}/android',
        environment: {
          'WHAT_S_NEW': whatsNew ?? '',
        });
  }

  Future<int> _getNextBuildNumber() async {
    final latestBuildNumber = await _getLatestBuildNumberFromGooglePlay();
    final nextBuildNumber = latestBuildNumber + 1;
    print('Next build number: $nextBuildNumber');
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
          'ios',
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
      throw Exception('Failed to build iOS app: $e');
    }
  }
}
