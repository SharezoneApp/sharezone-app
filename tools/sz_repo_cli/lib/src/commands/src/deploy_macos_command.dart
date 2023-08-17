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
import 'package:sz_repo_cli/src/common/src/apple_track.dart';

/// A map that maps the stage to the corresponding [AppleTrack].
final _macOsStageToTracks = {
  'stable': const AppStoreTrack(),
  'alpha': const TestFlightTrack('alpha'),
};

/// [DeployMacOsCommand] provides functionality for deploying the Sharezone macOS
/// app to the App Store or TestFlight.
///
/// This command automatically increments the build number and builds the app.
/// The Codemagic CLI tools are required for this process. Note that only the
/// "prod" flavor of the app is currently supported for macOS deployment.
///
/// You can customize deployment using command line arguments. Some of these
/// include:
///  - `private-key`: The App Store Connect API private key used for JWT
///    authentication.
///  - `key-id`: The App Store Connect API Key ID used to authenticate.
///  - `issuer-id`: The App Store Connect API Key Issuer ID used to
///    authenticate.
///  - `stage`: The stage to deploy to. Supports "stable" for App Store releases
///    and "alpha" for TestFlight releases.
///  - `whats-new`: Release notes either for TestFlight or App Store review
///    submission.
///
/// These options can either be provided via the command line or set as
/// environment variables (only applies for some of them). If any required
/// argument is missing, the deployment will fail.
class DeployMacOsCommand extends Command {
  final SharezoneRepo _repo;

  DeployMacOsCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _macOsStages,
        help:
            'The deployment stage to deploy to. The "stable" stage is used for App Store releases, the "alpha" stage is used for TestFlight releases. The value will be forwarded to the "sz build" command.',
        defaultsTo: 'stable',
      )
      ..addOption(
        keyIdOptionName,
        help:
            'The App Store Connect API Key ID used to authenticate. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If the parameter is not provided, the value of the APP_STORE_CONNECT_KEY_IDENTIFIER environment variable will be used. If no value is set, the deployment will fail. Example value: 1234567890',
      )
      ..addOption(
        issuerIdOptionName,
        help:
            'The App Store Connect API Key Issuer ID used to authenticate. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If the parameter is not provided, the value of the APP_STORE_CONNECT_ISSUER_ID environment variable will be used. If no value is set, the deployment will fail. Example value: 00000000-0000-0000-0000-000000000000',
      )
      ..addOption(
        privateKeyOptionName,
        help:
            'The App Store Connect API private key used for JWT authentication to communicate with Apple services. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If not provided, the value will be checked from the environment variable APP_STORE_CONNECT_PRIVATE_KEY. If not given, the key will be searched from the following directories in sequence for a private key file with the name AuthKey_<key_identifier>.p8: private_keys, ~/private_keys, ~/.private_keys, ~/.appstoreconnect/private_keys, where <key_identifier> is the value of --key-id. If no value is set, the deployment will fail.',
      )
      ..addOption(
        whatsNewOptionName,
        help:
            "Release notes either for TestFlight or App Store review submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 4000 characters. Example usage: --whats-new 'Bug fixes and performance improvements.'",
      );
  }

  static const privateKeyOptionName = 'private-key';
  static const keyIdOptionName = 'key-id';
  static const issuerIdOptionName = 'issuer-id';
  static const releaseStageOptionName = 'stage';
  static const whatsNewOptionName = 'whats-new';

  List<String> get _macOsStages => _macOsStageToTracks.keys.toList();

  @override
  String get description =>
      'Deploys the Sharezone macOS app to the App Store or TestFlight. Automatically bumps the build number and builds the app. Codemagic CLI tools are required.';

  @override
  String get name => 'macos';

  @override
  Future<void> run() async {
    await _throwIfCodemagiCliToolsAreNotInstalled();

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

  Future<void> _throwIfCodemagiCliToolsAreNotInstalled() async {
    // Check if "which -s app-store-connect" returns 0.
    // If not, throw an exception.
    final result = await runProcess(
      'which',
      ['-s', 'app-store-connect'],
    );
    if (result.exitCode != 0) {
      throw Exception(
        'Codemagic CLI tools are not installed. Docs to install them: https://github.com/codemagic-ci-cd/cli-tools#installing',
      );
    }
  }

  Future<int> _getNextBuildNumber() async {
    final latestBuildNumber = await _getLatestBuildNumberFromAppStoreConnect();
    final nextBuildNumber = latestBuildNumber + 1;
    print('Next build number: $nextBuildNumber');
    return nextBuildNumber;
  }

  /// Returns the latest build number from App Store and TestFligth all tracks.
  Future<int> _getLatestBuildNumberFromAppStoreConnect() async {
    try {
      // From https://appstoreconnect.apple.com/apps/1434868489/
      const appId = 1434868489;

      final issuerId = argResults![issuerIdOptionName] as String? ??
          Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
      final keyIdentifier = argResults![keyIdOptionName] as String? ??
          Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
      final privateKey = argResults![privateKeyOptionName] as String? ??
          Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

      final result = await runProcessSucessfullyOrThrow(
        'app-store-connect',
        [
          'get-latest-build-number',
          '$appId',
          '--platform',
          'MAC_OS',
          if (issuerId != null) ...[
            '--issuer-id',
            issuerId,
          ],
          if (keyIdentifier != null) ...[
            '--key-id',
            keyIdentifier,
          ],
          if (privateKey != null) ...[
            '--private-key',
            privateKey,
          ],
        ],
        // Using the app location as working direcorty because the default
        // location for the App Store Connect private key is
        // app/private_keys/AuthKey_{keyIdentifier}.p8.
        workingDirectory: _repo.sharezoneFlutterApp.location.path,
      );
      return int.parse(result.stdout);
    } catch (e) {
      throw Exception(
          'Failed to get latest build number from App Store Connect: $e');
    }
  }

  Future<void> _buildApp({required int buildNumber}) async {
    try {
      final stage = argResults![releaseStageOptionName] as String;
      await runProcessSucessfullyOrThrow(
        'fvm',
        [
          'dart',
          'run',
          'sz_repo_cli',
          'build',
          'macos',
          '--stage',
          stage,
          '--build-number',
          '$buildNumber',
        ],
        workingDirectory: _repo.sharezoneCiCdTool.path,
      );
    } catch (e) {
      throw Exception('Failed to build macOS app: $e');
    }
  }

  Future<void> _publish() async {
    final whatsNew = argResults![whatsNewOptionName] as String?;
    final issuerId = argResults![issuerIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
    final keyIdentifier = argResults![keyIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
    final privateKey = argResults![privateKeyOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

    final track = _getAppleTrack();
    await runProcessSucessfullyOrThrow(
      'app-store-connect',
      [
        'publish',
        '--path',
        'build/macos/Build/Products/Release/*.pkg',
        '--release-type',
        // The app version will be automatically released right after it has
        // been approved by App Review.
        'AFTER_APPROVAL',
        if (whatsNew != null) ...[
          '--whats-new',
          whatsNew,
        ],
        if (track is AppStoreTrack) ...[
          '--app-store',
        ],
        if (track is TestFlightTrack) ...[
          '--beta-group',
          track.groupName,
          '--testflight',
        ],
        if (issuerId != null) ...[
          '--issuer-id',
          issuerId,
        ],
        if (keyIdentifier != null) ...[
          '--key-id',
          keyIdentifier,
        ],
        if (privateKey != null) ...[
          '--private-key',
          privateKey,
        ],
      ],
      workingDirectory: _repo.sharezoneFlutterApp.location.path,
    );
  }

  AppleTrack _getAppleTrack() {
    final stage = argResults![releaseStageOptionName] as String;
    final track = _macOsStageToTracks[stage];
    if (track == null) {
      throw Exception('Unknown track for stage: $stage');
    }
    return track;
  }
}
