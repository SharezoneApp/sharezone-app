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

final _iosStages = [
  'stable',
  'alpha',
];

/// The different flavors of the iOS app that support deployment.
final _iosFlavors = [
  'prod',
];

/// [DeployIosCommand] provides functionality for deploying the Sharezone iOS
/// app to the App Store or TestFlight.
///
/// This command automatically increments the build number and builds the app.
/// The Codemagic CLI tools are required for this process. Note that only the
/// "prod" flavor of the app is currently supported for iOS deployment.
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
///  - `flavor`: The flavor to build for. Currently only "prod" flavor is
///    supported.
///  - `whats-new`: Release notes either for TestFlight or App Store review
///    submission.
///
/// These options can either be provided via the command line or set as
/// environment variables (only applies for some of them). If any required
/// argument is missing, the deployment will fail.
class DeployIosCommand extends Command {
  final SharezoneRepo _repo;

  DeployIosCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _iosStages,
        help:
            'The stage to deploy to. The "stable" stage is used for App Store releases, the "alpha" stage is used for TestFlight releases (publishing to a TestFligh group that matches "alpha" as a group name). Additionally, the stage value is passed to the build command.',
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
            'The App Store Connect API private key used for JWT authentication to communicate with Apple services. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If not provided, the key will be searched from the following directories in sequence for a private key file with the name AuthKey_<key_identifier>.p8: private_keys, ~/private_keys, ~/.private_keys, ~/.appstoreconnect/private_keys, where <key_identifier> is the value of --key-id. If not given, the value will be checked from the environment variable APP_STORE_CONNECT_PRIVATE_KEY. If no value is set, the deployment will fail.',
      )
      ..addOption(
        whatsNewOptionName,
        help:
            "Release notes either for TestFlight or App Store review submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 4000 characters. Example usage: --whats-new 'Bug fixes and performance improvements.'",
      )
      ..addOption(
        flavorOptionName,
        allowed: _iosFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      );
  }

  static const privateKeyOptionName = 'private-key';
  static const keyIdOptionName = 'key-id';
  static const issuerIdOptionName = 'issuer-id';
  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const whatsNewOptionName = 'whats-new';

  @override
  String get description =>
      'Deploys the Sharezone iOS app to the App Store or TestFlight. Automatically bumps the build number and builds the app. Codemagic CLI tools are required.';

  @override
  String get name => 'ios';

  @override
  Future<void> run() async {
    _throwIfFlavorIsNotSupportForDeployment();
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

  void _throwIfFlavorIsNotSupportForDeployment() {
    final flavor = argResults![flavorOptionName] as String;
    if (flavor != 'prod') {
      throw Exception(
        'Only the "prod" flavor is supported for iOS deployment.',
      );
    }
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

      final result = await runProcess(
        'app-store-connect',
        [
          'get-latest-build-number',
          '$appId',
          '--platform',
          'IOS',
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

  Future<void> _publish() async {
    final whatsNew = argResults![whatsNewOptionName] as String?;
    final stage = argResults![releaseStageOptionName] as String;
    final issuerId = argResults![issuerIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
    final keyIdentifier = argResults![keyIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
    final privateKey = argResults![privateKeyOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

    final isStable = stage == 'stable';
    await runProcess(
      'app-store-connect',
      [
        'publish',
        '--path',
        'build/ios/ipa/*.ipa',
        '--release-type',
        // The app version will be automatically released right after it has
        // been approved by App Review.
        'AFTER_APPROVAL',
        if (whatsNew != null) ...[
          '--whats-new',
          whatsNew,
        ],
        if (isStable) ...[
          '--app-store',
        ] else ...[
          '--beta-group',
          stage,
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
}
