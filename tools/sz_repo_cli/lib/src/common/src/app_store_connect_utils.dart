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
  required ArgResults argResults,
  required SharezoneRepo repo,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  final latestBuildNumber = await _getLatestBuildNumberFromAppStoreConnect(
    argResults: argResults,
    platform: platform,
    repo: repo,
  );
  final nextBuildNumber = latestBuildNumber + 1;
  print('Next build number: $nextBuildNumber');
  return nextBuildNumber;
}

/// Returns the latest build number from App Store and TestFligth all tracks.
Future<int> _getLatestBuildNumberFromAppStoreConnect({
  required ArgResults argResults,
  required SharezoneRepo repo,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  try {
    // From https://appstoreconnect.apple.com/apps/1434868489/
    const appId = 1434868489;

    final issuerId = argResults[issuerIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
    final keyIdentifier = argResults[keyIdOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
    final privateKey = argResults[privateKeyOptionName] as String? ??
        Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

    final result = await runProcessSucessfullyOrThrow(
      'app-store-connect',
      [
        'get-latest-build-number',
        '$appId',
        '--platform',
        platform,
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
      workingDirectory: repo.sharezoneFlutterApp.location.path,
    );
    return int.parse(result.stdout);
  } catch (e) {
    throw Exception(
        'Failed to get latest build number from App Store Connect: $e');
  }
}

Future<void> publishToAppStoreConnect({
  required ArgResults argResults,
  required SharezoneRepo repo,
  required String path,
  required Map<String, AppleTrack> stageToTracks,

  /// Should be either "IOS" or "MAC_OS".
  required String platform,
}) async {
  final whatsNew = argResults[whatsNewOptionName] as String?;
  final issuerId = argResults[issuerIdOptionName] as String? ??
      Platform.environment['APP_STORE_CONNECT_ISSUER_ID'];
  final keyIdentifier = argResults[keyIdOptionName] as String? ??
      Platform.environment['APP_STORE_CONNECT_KEY_IDENTIFIER'];
  final privateKey = argResults[privateKeyOptionName] as String? ??
      Platform.environment['APP_STORE_CONNECT_PRIVATE_KEY'];

  final track = _getAppleTrack(
    argResults: argResults,
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
    workingDirectory: repo.sharezoneFlutterApp.location.path,
  );
}

AppleTrack _getAppleTrack({
  required ArgResults argResults,
  required Map<String, AppleTrack> stageToTracks,
}) {
  final stage = argResults[releaseStageOptionName] as String;
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
