// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:sz_repo_cli/src/common/common.dart';

// All apps are deployed in the production firebase project but under different
// domains.
// All apps also have the production config (they use and display the production
// data).
final _webAppConfigs = {
  'alpha': _WebAppConfig('alpha-web-app', 'sharezone-c2bd8', 'prod'),
  'beta': _WebAppConfig('beta-web-app', 'sharezone-c2bd8', 'prod'),
  'prod': _WebAppConfig('release-web-app', 'sharezone-c2bd8', 'prod'),
};

/// Deploy the Sharezone web app to one of the several deploy sites (e.g. alpha
/// or production).
///
/// The command will automatically use the right firebase config as configured
/// inside [_webAppConfigs].
class DeployWebAppCommand extends Command {
  final SharezoneRepo _repo;

  DeployWebAppCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _webAppStages,
        allowedHelp: _deployCommandStageOptionHelp,
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
      );
  }

  Iterable<String> get _webAppStages => _webAppConfigs.keys;

  /// Used for helper text for deploy command.
  Map<String, String> get _deployCommandStageOptionHelp =>
      _webAppConfigs.map<String, String>((key, value) => MapEntry(
          key, '${value.firebaseProjectId}: ${value.deployTargetName}'));

  static const releaseStageOptionName = 'stage';
  static const firebaseDeployMessageOptionName = 'message';
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
    final webAppConfig = _getMatchingWebAppConfig(releaseStage);

    await runProcessSucessfullyOrThrow(
      'fvm',
      [
        'flutter',
        'build',
        'web',
        '--target',
        'lib/main_${webAppConfig.flavor}.dart',
        '--release',
        '--web-renderer',
        'canvaskit',
        '--dart-define',
        'DEVELOPMENT_STAGE=${releaseStage.toUpperCase()}'
      ],
      workingDirectory: _repo.sharezoneFlutterApp.location.path,
    );

    String? deployMessage;
    if (overriddenDeployMessage == null) {
      final currentCommit = await _getCurrentCommitHash();
      deployMessage = 'Commit: $currentCommit';
    }

    await runProcessSucessfullyOrThrow(
        'firebase',
        [
          'deploy',
          '--only',
          'hosting:${webAppConfig.deployTargetName}',
          '--project',
          webAppConfig.firebaseProjectId,
          '--message',
          deployMessage ?? overriddenDeployMessage!,
        ],
        workingDirectory: _repo.sharezoneFlutterApp.location.path,

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
        environment: {
          if (googleApplicationCredentialsFile != null)
            'GOOGLE_APPLICATION_CREDENTIALS':
                googleApplicationCredentialsFile.absolute.path,
        });
  }

  File? _parseCredentialsFile(ArgResults _argResults) {
    File? googleApplicationCredentialsFile;
    final _path =
        _argResults[googleApplicationCredentialsOptionName] as String?;
    if (_path != null) {
      googleApplicationCredentialsFile = File(_path);
      final exists = googleApplicationCredentialsFile.existsSync();
      if (!exists) {
        print(
            "--$googleApplicationCredentialsOptionName passed '$_path' but the file doesn't exist at this path. Working directory is ${Directory.current}");
      }
    }
    return googleApplicationCredentialsFile;
  }

  _WebAppConfig _getMatchingWebAppConfig(String releaseStage) {
    final _app = _webAppConfigs[releaseStage];

    if (_app == null) {
      print(
          'Given release stage $releaseStage does not match one the expected values: $_webAppStages');
      throw ToolExit(2);
    }

    if (isVerbose) {
      print('Got webApp config: $_app');
    }
    return _app;
  }

  String _parseReleaseStage(ArgResults _argResults) {
    final releaseStage = _argResults[releaseStageOptionName] as String?;
    if (releaseStage == null) {
      print(
          'Expected --$releaseStageOptionName option. Possible values: $_webAppStages');
      throw ToolExit(1);
    }
    return releaseStage;
  }

  String? _parseDeployMessage(ArgResults _argResults) {
    final overriddenDeployMessageOrNull =
        _argResults[firebaseDeployMessageOptionName] as String?;
    return overriddenDeployMessageOrNull;
  }

  Future<String> _getCurrentCommitHash() async {
    final res = await runProcess('git', ['rev-parse', 'HEAD']);
    if (res.stdout == null || (res.stdout as String).isEmpty) {
      print(
          'Could not receive the current commit hash: (${res.exitCode}) ${res.stderr}.');
      throw ToolExit(15);
    }
    final currentCommit = res.stdout;
    if (isVerbose) {
      print('Got current commit hash: $currentCommit');
    }
    return currentCommit;
  }
}

class _WebAppConfig {
  /// As in /app/.firebaserc
  final String deployTargetName;

  /// E.g. sharezone-c2bd8 or sharezone-debug
  final String firebaseProjectId;

  /// E.g. prod or dev
  ///
  /// Will be used to select the correct main file, e.g. main_prod.dart for
  /// prod.
  final String flavor;

  const _WebAppConfig(
    this.deployTargetName,
    this.firebaseProjectId,
    this.flavor,
  );

  @override
  String toString() =>
      '_WebApp(deployTargetName: $deployTargetName, firebaseProjectId: $firebaseProjectId, flavor: $flavor)';
}
