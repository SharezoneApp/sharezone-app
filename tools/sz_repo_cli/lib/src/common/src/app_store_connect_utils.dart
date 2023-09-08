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
import 'package:sz_repo_cli/src/common/src/throw_if_command_is_not_installed.dart';

const certificateKeyOptionName = 'certificate-key';
const privateKeyOptionName = 'private-key';
const keyIdOptionName = 'key-id';
const issuerIdOptionName = 'issuer-id';
const whatsNewOptionName = 'whats-new';
const releaseStageOptionName = 'stage';

/// Sets up signing that is required to deploy a macOS or iOS app.
Future<void> setUpSigning({
  required AppleSigningConfig config,
}) async {
  await _keychainInitialize();
  await _fetchSigningFiles(config: config);
  await _keychainAddCertificates();
  await _xcodeProjectUseProfiles();
}

Future<void> _keychainInitialize() async {
  await runProcessSucessfullyOrThrow('keychain', ['initialize']);
}

Future<void> _fetchSigningFiles({
  required AppleSigningConfig config,
}) async {
  const bundleId = 'de.codingbrain.sharezone';
  await runProcessSucessfullyOrThrow(
    'app-store-connect',
    [
      'fetch-signing-files',
      bundleId,
      '--platform',
      config.platform.toUppercaseSnakeCase(),
      '--type',
      config.type.toUppercaseSnakeCase(),
      '--issuer-id',
      config.appStoreConnectConfig.issuerId,
      '--key-id',
      config.appStoreConnectConfig.keyId,
      '--private-key',
      config.appStoreConnectConfig.privateKey,
      '--create'
    ],
  );
}

Future<void> _keychainAddCertificates() async {
  await runProcessSucessfullyOrThrow('keychain', ['add-certificates']);
}

Future<void> _xcodeProjectUseProfiles() async {
  await runProcessSucessfullyOrThrow('xcode-project', ['use-profiles']);
}

Future<int> getNextBuildNumberFromAppStoreConnect({
  required String workingDirectory,
  required AppStoreConnectConfig appStoreConnectConfig,
  required ApplePlatform platform,
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
  required ApplePlatform platform,
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
        platform.toUppercaseSnakeCase(),
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

Future<void> throwIfCodemagicCliToolsAreNotInstalled() async {
  await throwIfCommandIsNotInstalled(
    command: 'app-store-connect',
    instructionsToInstall:
        'Docs to install them: https://github.com/codemagic-ci-cd/cli-tools#installing',
  );
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

void addCertificateKey(ArgParser argParser) {
  argParser.addOption(
    certificateKeyOptionName,
    help:
        'Private key used to generate the certificate. If not provided, the value will be checked from the environment variable CERTIFICATE_PRIVATE_KEY. If no value is set, the deployment will fail.',
  );
}

/// Configs that are required to sign an iOS or macOS app.
class AppleSigningConfig {
  final AppStoreConnectConfig appStoreConnectConfig;
  final String certificatePrivateKey;
  final ApplePlatform platform;
  final ProvisioningProfileType type;

  const AppleSigningConfig({
    required this.appStoreConnectConfig,
    required this.certificatePrivateKey,
    required this.platform,
    required this.type,
  });

  factory AppleSigningConfig.create({
    required ArgResults argResults,
    required Map<String, String> environment,
    required ApplePlatform platform,
    required ProvisioningProfileType type,
  }) {
    final appStoreConnectConfig = AppStoreConnectConfig.create(
      argResults,
      environment,
    );

    final certificatePrivateKey =
        argResults[certificateKeyOptionName] as String? ??
            Platform.environment['CERTIFICATE_PRIVATE_KEY'];

    if (certificatePrivateKey == null) {
      throw Exception(
          'No certificate private key provided. Either provide it via the command line or set the CERTIFICATE_PRIVATE_KEY environment variable.');
    }

    return AppleSigningConfig(
      appStoreConnectConfig: appStoreConnectConfig,
      certificatePrivateKey: certificatePrivateKey,
      platform: platform,
      type: type,
    );
  }
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

/// Platforms that can be used to deploy an Apple app.
enum ApplePlatform {
  macOS,
  iOS;

  String toUppercaseSnakeCase() {
    switch (this) {
      case ApplePlatform.iOS:
        return 'IOS';
      case ApplePlatform.macOS:
        return 'MAC_OS';
    }
  }
}

/// Types of provisioning profiles.
///
/// See https://github.com/codemagic-ci-cd/cli-tools/blob/master/docs/app-store-connect/fetch-signing-files.md#--typeios_app_adhoc--ios_app_development--ios_app_inhouse--ios_app_store--mac_app_development--mac_app_direct--mac_app_store--mac_catalyst_app_development--mac_catalyst_app_direct--mac_catalyst_app_store--tvos_app_adhoc--tvos_app_development--tvos_app_inhouse--tvos_app_store.
enum ProvisioningProfileType {
  // There are more types, but these are the ones we need right now.
  macAppStore,
  iOsAppStore,
  iOsAppAdhoc;

  String toUppercaseSnakeCase() {
    switch (this) {
      case ProvisioningProfileType.macAppStore:
        return 'MAC_APP_STORE';
      case ProvisioningProfileType.iOsAppStore:
        return 'IOS_APP_STORE';
      case ProvisioningProfileType.iOsAppAdhoc:
        return 'IOS_APP_ADHOC';
    }
  }
}
