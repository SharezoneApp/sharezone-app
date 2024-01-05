// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

/// Maps the different release stages to the corresponding Firebase Hosting
/// target.
final _stageToTarget = {
  'alpha': 'alpha-web-app',
  'beta': 'beta-web-app',
  'stable': 'release-web-app',
};

/// Maps the different flavors to the corresponding Firebase project ID.
final _flavorToProjectId = {
  'prod': 'sharezone-c2bd8',
  'dev': 'sharezone-debug',
};

/// The different flavors of the web app that support deployment.
final _webFlavors = [
  'prod',
  'dev',
];

/// Deploy the Sharezone web app to one of the several deploy sites (e.g. alpha
/// or production).
///
/// The command will automatically use the right firebase config as configured
/// inside [_stageToTarget].
class DeployWebAppCommand extends CommandBase {
  DeployWebAppCommand(super.context) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _webAppStages,
      )
      ..addOption(
        firebaseDeployMessageOptionName,
        help:
            '(Optional) The message given to "firebase deploy --only:hosting" via the "--message" flag. Will default to the current commit hash.',
      )
      ..addOption(
        googleApplicationCredentialsOptionName,
        help:
            'Path to location of credentials .json file used to authenticate deployment. Should only be used for CI/CD, developers should use "firebase login" instead.',
      )
      ..addOption(
        flavorOptionName,
        allowed: _webFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      );
  }

  Iterable<String> get _webAppStages => _stageToTarget.keys;

  static const releaseStageOptionName = 'stage';
  static const firebaseDeployMessageOptionName = 'message';
  static const flavorOptionName = 'flavor';
  static const googleApplicationCredentialsOptionName = 'credentials';

  @override
  String get description =>
      'Deploy the Sharezone web app in the given environment';

  @override
  String get name => 'web-app';

  @override
  Future<void> run() async {
    // Its less work to just print everything right now instead of selectively
    // print and add custom print statements for non-verboes output.
    // One might add non-verbose output in the future but right now this is
    // easier.
    isVerbose = true;

    final googleApplicationCredentialsFile = _parseCredentialsFile(argResults!);

    final overriddenDeployMessage = _parseDeployMessage(argResults!);
    final releaseStage = _parseReleaseStage(argResults!);
    final flavor = argResults![flavorOptionName] as String;

    await processRunner.runCommand([
      'fvm',
      'dart',
      'run',
      'sz_repo_cli',
      'build',
      'web',
      '--flavor',
      flavor,
      '--stage',
      releaseStage
    ], workingDirectory: repo.sharezoneCiCdTool.location);

    String? deployMessage;
    if (overriddenDeployMessage == null) {
      final currentCommit = await _getCurrentCommitHash(processRunner);
      deployMessage = 'Commit: $currentCommit';
    }

    final firebaseHostingTarget = _stageToTarget[releaseStage]!;
    final firebaseProjectId = _flavorToProjectId[flavor]!;
    await processRunner.run(
      [
        'firebase',
        'deploy',
        '--only',
        'hosting:$firebaseHostingTarget',
        '--project',
        firebaseProjectId,
        '--message',
        deployMessage ?? overriddenDeployMessage!,
      ],
      workingDirectory: repo.sharezoneFlutterApp.location,
      addedEnvironment: {
        // If we run this inside the CI/CD system we want this call to be
        // authenticated via the GOOGLE_APPLICATION_CREDENTIALS environment
        // variable.
        //
        // Unfortunately it doesn't work to export the environment variable
        // inside the CI/CD job and let the firebase cli use it automatically.
        // Even when using [Process.includeParentEnvironment] the variables
        // are not passed to the firebase cli.
        //
        // Thus the CI/CD script can pass the
        // [googleApplicationCredentialsFile] manually via an command line
        // option and we set the GOOGLE_APPLICATION_CREDENTIALS manually
        // below.
        if (googleApplicationCredentialsFile != null)
          'GOOGLE_APPLICATION_CREDENTIALS':
              googleApplicationCredentialsFile.absolute.path
      },
    );
  }

  File? _parseCredentialsFile(ArgResults argResults) {
    File? googleApplicationCredentialsFile;
    final path = argResults[googleApplicationCredentialsOptionName] as String?;
    if (path != null) {
      googleApplicationCredentialsFile = fileSystem.file(path);
      final exists = googleApplicationCredentialsFile.existsSync();
      if (!exists) {
        stdout.writeln(
            "--$googleApplicationCredentialsOptionName passed '$path' but the file doesn't exist at this path. Working directory is ${Directory.current}");
      }
    }
    return googleApplicationCredentialsFile;
  }

  String _parseReleaseStage(ArgResults argResults) {
    final releaseStage = argResults[releaseStageOptionName] as String?;
    if (releaseStage == null) {
      stderr.writeln(
          'Expected --$releaseStageOptionName option. Possible values: $_webAppStages');
      throw ToolExit(1);
    }
    return releaseStage;
  }

  String? _parseDeployMessage(ArgResults argResults) {
    final overriddenDeployMessageOrNull =
        argResults[firebaseDeployMessageOptionName] as String?;
    return overriddenDeployMessageOrNull;
  }

  Future<String> _getCurrentCommitHash(ProcessRunner processRunner) async {
    final res = await processRunner.run(['git', 'rev-parse', 'HEAD']);
    if (res.stdout.isEmpty) {
      stderr.writeln(
          'Could not receive the current commit hash: (${res.exitCode}) ${res.stderr}.');
      throw ToolExit(15);
    }
    final currentCommit = res.stdout;
    if (isVerbose) {
      stdout.writeln('Got current commit hash: $currentCommit');
    }
    return currentCommit;
  }
}
