// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:args/args.dart';
import 'package:sz_repo_cli/src/common/src/apple_track.dart';
import 'package:sz_repo_cli/src/common/src/run_process.dart';
import 'package:sz_repo_cli/src/common/src/sharezone_repo.dart';

const privateKeyOptionName = 'private-key';
const keyIdOptionName = 'key-id';
const issuerIdOptionName = 'issuer-id';
const whatsNewOptionName = 'whats-new';
const releaseStageOptionName = 'stage';

Future<int> getNextBuildNumberFromAppStoreConnect({
  required String workingDirectory,
  required AppStoreConnectConfig appStoreConnectConfig,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  final latestBuildNumber = await _getLatestBuildNumberFromAppStoreConnect(
    platform: platform,
    workingDirectory: workingDirectory,
    appStoreConnectConfig: appStoreConnectConfig,
  );
  final nextBuildNumber = latestBuildNumber + 1;
  stdout.writeln('Next build number: $nextBuildNumber');
  return nextBuildNumber;
}

/// Returns the latest build number from App Store and all TestFlight tracks.
Future<int> _getLatestBuildNumberFromAppStoreConnect({
  required String workingDirectory,
  required AppStoreConnectConfig appStoreConnectConfig,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  try {
    // From https://appstoreconnect.apple.com/apps/1434868489/
    const appId = 1434868489;

    final result = await runProcessSucessfullyOrThrow(
      'app-store-connect',
      [
        'get-latest-build-number',
        '$appId',
        '--platform',
        platform,
        '--issuer-id',
        appStoreConnectConfig.issuerId,
        '--key-id',
        appStoreConnectConfig.keyId,
        '--private-key',
        appStoreConnectConfig.privateKey,
      ],
      workingDirectory: workingDirectory,
    );
    return int.parse(result.stdout);
  } catch (e) {
    throw Exception(
        'Failed to get latest build number from App Store Connect: $e');
  }
}

Future<void> publishToAppStoreConnect({
  required SharezoneRepo repo,
  required String path,
  required Map<String, AppleTrack> stageToTracks,
  required String stage,
  required AppStoreConnectConfig appStoreConnectConfig,
  String? whatsNew,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  final track = _getAppleTrack(
    stage: stage,
    stageToTracks: stageToTracks,
  );
  await runProcessSucessfullyOrThrow(
    'app-store-connect',
    [
      'publish',
      '--path',
      path,
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
      '--issuer-id',
      appStoreConnectConfig.issuerId,
      '--key-id',
      appStoreConnectConfig.keyId,
      '--private-key',
      appStoreConnectConfig.privateKey,
    ],
    workingDirectory: repo.sharezoneFlutterApp.location.path,
  );
}

AppleTrack _getAppleTrack({
  required String stage,
  required Map<String, AppleTrack> stageToTracks,
}) {
  final track = stageToTracks[stage];
  if (track == null) {
    throw Exception('Unknown track for stage: $stage');
  }
  return track;
}

Future<void> throwIfCodemagiCliToolsAreNotInstalled() async {
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

void addWhatsNewOption(ArgParser argParser) {
  argParser.addOption(
    whatsNewOptionName,
    help:
        "Release notes either for TestFlight or App Store review submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 4000 characters. Example usage: --whats-new 'Bug fixes and performance improvements.'",
  );
}

void addAppStoreConnectKeyIdOption(ArgParser argParser) {
  argParser.addOption(
    keyIdOptionName,
    help:
        'The App Store Connect API Key ID used to authenticate. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If the parameter is not provided, the value of the APP_STORE_CONNECT_KEY_IDENTIFIER environment variable will be used. If no value is set, the deployment will fail. Example value: 1234567890',
  );
}

void addAppStoreConnectIssuerIdOption(ArgParser argParser) {
  argParser.addOption(
    issuerIdOptionName,
    help:
        'The App Store Connect API Key Issuer ID used to authenticate. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If the parameter is not provided, the value of the APP_STORE_CONNECT_ISSUER_ID environment variable will be used. If no value is set, the deployment will fail. Example value: 00000000-0000-0000-0000-000000000000',
  );
}

void addAppStoreConnectPrivateKey(ArgParser argParser) {
  argParser.addOption(
    privateKeyOptionName,
    help:
        'The App Store Connect API private key used for JWT authentication to communicate with Apple services. This can be found in the App Store Connect Developer Portal. Learn more at https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api. If not provided, the value will be checked from the environment variable APP_STORE_CONNECT_PRIVATE_KEY. If not given, the key will be searched from the following directories in sequence for a private key file with the name AuthKey_<key_identifier>.p8: private_keys, ~/private_keys, ~/.private_keys, ~/.appstoreconnect/private_keys, where <key_identifier> is the value of --key-id. If no value is set, the deployment will fail.',
  );
}

class AppStoreConnectConfig {
  final String privateKey;
  final String keyId;
  final String issuerId;

  const AppStoreConnectConfig({
    required this.privateKey,
    required this.keyId,
    required this.issuerId,
  });

  factory AppStoreConnectConfig.create(
    ArgResults argResults,
    Map<String, String> environment,
  ) {
    final issuerId = argResults[issuerIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
    final keyIdentifier = argResults[keyIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
    final privateKey = argResults[privateKeyOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

    if (issuerId == null) {
      throw Exception(
          'No issuer ID provided. Either provide it via the command line or set the APP_STORE_CONNECT_ISSUER_ID environment variable.');
    }

    if (keyIdentifier == null) {
      throw Exception(
          'No key ID provided. Either provide it via the command line or set the APP_STORE_CONNECT_KEY_IDENTIFIER environment variable.');
    }

    if (privateKey == null) {
      throw Exception(
          'No private key provided. Either provide it via the command line or set the APP_STORE_CONNECT_PRIVATE_KEY environment variable.');
    }

    return AppStoreConnectConfig(
      privateKey: privateKey,
      keyId: keyIdentifier,
      issuerId: issuerId,
    );
  }
}
