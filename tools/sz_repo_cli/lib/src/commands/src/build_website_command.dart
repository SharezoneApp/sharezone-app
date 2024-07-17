// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';

/// The different flavors of the website.
final _websiteFlavors = [
  'prod',
  'dev',
];

class BuildWebsiteCommand extends CommandBase {
  BuildWebsiteCommand(super.context) {
    argParser.addOption(
      flavorOptionName,
      allowed: _websiteFlavors,
      help: 'The flavor to build for.',
      defaultsTo: 'prod',
    );
  }

  static const flavorOptionName = 'flavor';

  @override
  String get description => 'Build the Sharezone website in release mode.';

  @override
  String get name => 'website';

  /// Path to the web folder of the website: `website/web/`.
  String get _getWebFolderPath =>
      repo.sharezoneWebsite.location.childDirectory('web').path;

  @override
  Future<void> run() async {
    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    try {
      await _renameRobotsTxt();
      await _buildWebsite();
    } finally {
      await _revertRenamedRobotsTxt();
    }

    stdout.writeln('Build finished 🎉 ');
  }

  Future<void> _buildWebsite() async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      await processRunner.runCommand(
        [
          'flutter',
          'build',
          'web',
          '--release',
          '--dart-define',
          'FLAVOR=$flavor',
          '--pwa-strategy',
          'none',
        ],
        workingDirectory: repo.sharezoneWebsite.location,
      );
    } catch (e) {
      throw Exception('Failed to build website: $e');
    }
  }

  Future<void> _renameRobotsTxt() async {
    final flavor = argResults![flavorOptionName] as String;
    stdout.writeln(_getWebFolderPath);
    final file = File('$_getWebFolderPath/robots_$flavor.txt');
    await file.rename('$_getWebFolderPath/robots.txt');
  }

  Future<void> _revertRenamedRobotsTxt() async {
    final flavor = argResults![flavorOptionName] as String;
    final file = File('$_getWebFolderPath/robots.txt');
    await file.rename('$_getWebFolderPath/robots_$flavor.txt');
  }
}
