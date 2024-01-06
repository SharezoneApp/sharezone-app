// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// We need to ignore the lint "unnecessary_string_escapes" because in the
// "_createSignedPackage" method we need to use the escape character "\" to
// escape the "$" character in the bash command.
//
// ignore_for_file: unnecessary_string_escapes

import 'dart:io';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/app_store_connect_utils.dart';
import 'package:sz_repo_cli/src/common/src/apple_track.dart';

/// A map that maps the stage to the corresponding [AppleTrack].
final _macOsStageToTracks = {
  'stable': const AppStoreTrack(),
  'alpha': const TestFlightTrack('alpha'),
};

/// The different flavors of the macOS app that support deployment.
final _macOsFlavors = [
  'prod',
  'dev',
];

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
class DeployMacOsCommand extends CommandBase {
  DeployMacOsCommand(super.context) {
    argParser.addOption(
      releaseStageOptionName,
      abbr: 's',
      allowed: _macOsStages,
      help:
          'The deployment stage to deploy to. The "stable" stage is used for App Store releases, the "alpha" stage is used for TestFlight releases. The value will be forwarded to the "sz build" command.',
      defaultsTo: 'stable',
    );
    argParser.addOption(
      flavorOptionName,
      allowed: _macOsFlavors,
      help: 'The flavor to build for. Only the "prod" flavor is supported.',
      defaultsTo: 'prod',
    );

    addAppStoreConnectKeyIdOption(argParser);
    addAppStoreConnectIssuerIdOption(argParser);
    addAppStoreConnectPrivateKey(argParser);
    addCertificateKey(argParser);
    addWhatsNewOption(argParser);
  }

  static const flavorOptionName = 'flavor';

  List<String> get _macOsStages => _macOsStageToTracks.keys.toList();

  @override
  String get description =>
      'Deploys the Sharezone macOS app to the App Store or TestFlight. Automatically bumps the build number and builds the app. Codemagic CLI tools are required.';

  @override
  String get name => 'macos';

  @override
  Future<void> run() async {
    await throwIfCodemagicCliToolsAreNotInstalled(processRunner);

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    const platform = ApplePlatform.macOS;

    try {
      await setUpSigning(
        processRunner,
        config: AppleSigningConfig.create(
          argResults: argResults!,
          environment: Platform.environment,
          // Even though we deploy for macOS, we need to use the iOS platform
          // here because our bundle ID is only registered for iOS. However,
          // this doesn't matter for the signing process.
          //
          // More details: https://github.com/codemagic-ci-cd/cli-tools/issues/314
          platform: ApplePlatform.iOS,
          type: ProvisioningProfileType.macAppStore,
        ),
        platform: platform,
      );

      final appStoreConnectConfig = AppStoreConnectConfig.create(
        argResults!,
        Platform.environment,
      );

      final buildNumber = await getNextBuildNumberFromAppStoreConnect(
        fileSystem,
        processRunner,
        appStoreConnectConfig: appStoreConnectConfig,
        platform: platform,
        // Using the app location as working directory because the default
        // location for the App Store Connect private key is
        // app/private_keys/AuthKey_{keyIdentifier}.p8.
        workingDirectory: repo.sharezoneFlutterApp.path,
      );

      await _buildApp(processRunner, buildNumber: buildNumber);

      await _createSignedPackage();
      await publishToAppStoreConnect(
        processRunner,
        appStoreConnectConfig: appStoreConnectConfig,
        stage: argResults![releaseStageOptionName] as String,
        whatsNew: argResults![whatsNewOptionName] as String?,
        path: '*.pkg',
        repo: repo,
        stageToTracks: _macOsStageToTracks,
      );
      stdout.writeln('Deployment finished 🎉 ');
    } finally {
      // Fixes potential authentication issues after running keychain commands.
      // Only really necessary when running on local machines.
      await keychainUseLogin(processRunner);
    }
  }

  Future<void> _buildApp(ProcessRunner processRunner,
      {required int buildNumber}) async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      await processRunner.runCommand(
        [
          'fvm',
          'dart',
          'run',
          'sz_repo_cli',
          'build',
          'macos',
          '--flavor',
          flavor,
          '--stage',
          stage,
          '--build-number',
          '$buildNumber',
        ],
        workingDirectory: repo.sharezoneCiCdTool.location,
      );
    } catch (e) {
      throw Exception('Failed to build macOS app: $e');
    }
  }

  /// Creates a signed macOS package from the built app and stores it in the
  /// working directory.
  ///
  /// Usually the path to the signed macOS package is `app/Sharezone.pkg`.
  ///
  /// The steps are copied from the Flutter docs. You can find more details
  /// here: https://docs.flutter.dev/deployment/macos#create-a-build-archive-with-codemagic-cli-tools
  Future<void> _createSignedPackage() async {
    await processRunner.run(
      [
        'bash',
        '-c',
        '''APP_NAME=\$(find \$(pwd) -name "*.app") && \
PACKAGE_NAME=\$(basename "\$APP_NAME" .app).pkg && \
xcrun productbuild --component "\$APP_NAME" /Applications/ unsigned.pkg && \
INSTALLER_CERT_NAME=\$(keychain list-certificates | jq -r '.[] | select(.common_name | contains("Mac Developer Installer")) | .common_name' | head -1) && \
xcrun productsign --sign "\$INSTALLER_CERT_NAME" unsigned.pkg "\$PACKAGE_NAME" && \
rm -f unsigned.pkg'''
      ],
      workingDirectory: repo.sharezoneFlutterApp.location,
    );
  }
}
