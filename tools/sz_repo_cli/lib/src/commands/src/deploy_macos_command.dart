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
import 'package:sz_repo_cli/src/common/src/app_store_connect_utils.dart';
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
    argParser.addOption(
      releaseStageOptionName,
      abbr: 's',
      allowed: _macOsStages,
      help:
          'The deployment stage to deploy to. The "stable" stage is used for App Store releases, the "alpha" stage is used for TestFlight releases. The value will be forwarded to the "sz build" command.',
      defaultsTo: 'stable',
    );

    addAppStoreConnectKeyIdOption(argParser);
    addAppStoreConnectIssuerIdOption(argParser);
    addAppStoreConnectPrivateKey(argParser);
    addWhatsNewOption(argParser);
  }

  List<String> get _macOsStages => _macOsStageToTracks.keys.toList();

  @override
  String get description =>
      'Deploys the Sharezone macOS app to the App Store or TestFlight. Automatically bumps the build number and builds the app. Codemagic CLI tools are required.';

  @override
  String get name => 'macos';

  @override
  Future<void> run() async {
    await throwIfCodemagicCliToolsAreNotInstalled();

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    final appStoreConnectConfig = AppStoreConnectConfig.create(
      argResults!,
      Platform.environment,
    );

    const platform = 'MAC_OS';
    final buildNumber = await getNextBuildNumberFromAppStoreConnect(
      appStoreConnectConfig: appStoreConnectConfig,
      platform: platform,
      // Using the app location as working direcorty because the default
      // location for the App Store Connect private key is
      // app/private_keys/AuthKey_{keyIdentifier}.p8.
      workingDirectory: _repo.sharezoneFlutterApp.path,
    );
    await _buildApp(buildNumber: buildNumber);
    await publishToAppStoreConnect(
      appStoreConnectConfig: appStoreConnectConfig,
      stage: argResults![releaseStageOptionName] as String,
      whatsNew: argResults![whatsNewOptionName] as String?,
      path: 'build/macos/Build/Products/Release/*.pkg',
      platform: platform,
      repo: _repo,
      stageToTracks: _macOsStageToTracks,
    );

    stdout.writeln('Deployment finished 🎉 ');
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
}
