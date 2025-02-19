// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';

/// The different flavors of the console.
final _websiteFlavors = ['prod', 'dev'];

class BuildConsoleCommand extends CommandBase {
  BuildConsoleCommand(super.context) {
    argParser.addOption(
      flavorOptionName,
      allowed: _websiteFlavors,
      help: 'The flavor to build for.',
      defaultsTo: 'prod',
    );
  }

  static const flavorOptionName = 'flavor';

  @override
  String get description =>
      'Build the Sharezone admin console in release mode.';

  @override
  String get name => 'console';

  @override
  Future<void> run() async {
    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    await _buildConsole();
    stdout.writeln('Build finished 🎉 ');
  }

  Future<void> _buildConsole() async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      await processRunner.runCommand([
        'flutter',
        'build',
        'web',
        '--release',
        '--dart-define',
        'FLAVOR=$flavor',
      ], workingDirectory: repo.sharezoneAdminConsole.location);
    } catch (e) {
      throw Exception('Failed to build console: $e');
    }
  }
}
