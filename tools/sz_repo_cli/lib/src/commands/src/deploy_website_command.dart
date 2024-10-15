// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:args/args.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/deploy_utils.dart';

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
class DeployWebsiteCommand extends CommandBase {
  DeployWebsiteCommand(super.context) {
    argParser
      ..addOption(
        firebaseDeployMessageOptionName,
        help:
            '(Optional) The message given to "firebase deploy --only:hosting" via the "--message" flag. Will default to the current commit hash.',
      )
      ..addOption(
        flavorOptionName,
        allowed: _webFlavors,
        help: 'The flavor to build for.',
        defaultsTo: 'prod',
      );
  }

  static const firebaseDeployMessageOptionName = 'message';
  static const flavorOptionName = 'flavor';

  @override
  String get description =>
      'Deploy the Sharezone website in the given environment';

  @override
  String get name => 'website';

  @override
  Future<void> run() async {
    // Its less work to just print everything right now instead of selectively
    // print and add custom print statements for non-verbose output.
    // One might add non-verbose output in the future but right now this is
    // easier.
    isVerbose = true;

    await _build();
    await _deploy();
  }

  Future<void> _build() async {
    final flavor = argResults![flavorOptionName] as String;
    await processRunner.runCommand([
      'dart',
      'run',
      'sz_repo_cli',
      'build',
      'website',
      '--flavor',
      flavor,
    ], workingDirectory: repo.sharezoneCiCdTool.location);
  }

  Future<void> _deploy() async {
    final flavor = argResults![flavorOptionName] as String;
    final firebaseProjectId = _flavorToProjectId[flavor]!;

    final deployMessage = await _getDeployMessage();

    await processRunner.run(
      [
        'firebase',
        'deploy',
        '--project',
        firebaseProjectId,
        '--message',
        deployMessage,
      ],
      workingDirectory: repo.sharezoneWebsite.location,
    );
  }

  Future<String> _getDeployMessage() async {
    final overriddenDeployMessage = _parseDeployMessage(argResults!);

    String? deployMessage;
    if (overriddenDeployMessage == null) {
      final currentCommit = await getCurrentCommitHash(processRunner);
      deployMessage = 'Commit: $currentCommit';
    }

    return deployMessage ?? overriddenDeployMessage!;
  }

  String? _parseDeployMessage(ArgResults argResults) {
    final overriddenDeployMessageOrNull =
        argResults[firebaseDeployMessageOptionName] as String?;
    return overriddenDeployMessageOrNull;
  }
}
