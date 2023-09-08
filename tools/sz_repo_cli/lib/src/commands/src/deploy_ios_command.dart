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
final _iosStageToTracks = {
  'stable': const AppStoreTrack(),
  'alpha': const TestFlightTrack('alpha'),
  'beta': const TestFlightTrack('beta'),
};

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
            'The deployment stage to deploy to. The "stable" stage is used for App Store releases, the "alpha" stage is used for TestFlight releases. The value will be forwarded to the "sz build" command.',
        defaultsTo: 'stable',
      )
      ..addOption(
        exportOptionsPlistName,
        help:
            'Export an IPA with these options. See "xcodebuild -h" for available exportOptionsPlist keys.',
      )
      ..addOption(
        flavorOptionName,
        allowed: _iosFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      );

    addAppStoreConnectKeyIdOption(argParser);
    addAppStoreConnectIssuerIdOption(argParser);
    addAppStoreConnectPrivateKey(argParser);
    addWhatsNewOption(argParser);
  }

  static const flavorOptionName = 'flavor';
  static const exportOptionsPlistName = 'export-options-plist';

  List<String> get _iosStages => _iosStageToTracks.keys.toList();

  @override
  String get description =>
      'Deploys the Sharezone iOS app to the App Store or TestFlight. Automatically bumps the build number and builds the app. Codemagic CLI tools are required.';

  @override
  String get name => 'ios';

  @override
  Future<void> run() async {
    _throwIfFlavorIsNotSupportForDeployment();
    await throwIfCodemagiCliToolsAreNotInstalled();

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    final appStoreConnectConfig = AppStoreConnectConfig.create(
      argResults!,
      Platform.environment,
    );

    const platform = 'IOS';
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
      platform: platform,
      path: 'build/ios/ipa/*.ipa',
      repo: _repo,
      stageToTracks: _iosStageToTracks,
    );

    stdout.writeln('Deployment finished 🎉 ');
  }

  void _throwIfFlavorIsNotSupportForDeployment() {
    final flavor = argResults![flavorOptionName] as String;
    if (flavor != 'prod') {
      throw Exception(
        'Only the "prod" flavor is supported for iOS deployment.',
      );
    }
  }

  Future<void> _buildApp({required int buildNumber}) async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      final exportOptionsPlist = argResults![exportOptionsPlistName] as String?;
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
          if (exportOptionsPlist != null) ...[
            '--export-options-plist',
            exportOptionsPlist,
          ],
        ],
        workingDirectory: _repo.sharezoneCiCdTool.path,
      );
    } catch (e) {
      throw Exception('Failed to build iOS app: $e');
    }
  }
}
