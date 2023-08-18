// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/run_source_of_truth_command.dart';

class FormatCommand extends ConcurrentCommand {
  FormatCommand(SharezoneRepo repo) : super(repo);

  @override
  final String name = 'format';

  @override
  final String description = 'Formats our source code.\n'
      'Does not fail if packages are not formatted properly.';

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 3);

  @override
  Future<void> runSetup() async {
    await _throwIfPrettierIsNotInstalled();

    await _formatActionFiles(repo: repo);
  }

  @override
  Future<void> runTaskForPackage(Package package) async =>
      await formatCode(package);

  Future<void> _throwIfPrettierIsNotInstalled() async {
    if (Platform.isWindows) {
      // We skip this check on Windows because "which -s" is not available.
      return;
    }

    // Check if "which -s prettier" returns 0.
    // If not, throw an exception.
    final result = await runProcess(
      'which',
      ['-s', 'prettier'],
    );
    if (result.exitCode != 0) {
      throw Exception(
        'Prettier is not installed. Run `npm install -g prettier` to install it.',
      );
    }
  }

  Future<void> _formatActionFiles({
    required SharezoneRepo repo,
  }) async {
    final results = await runSourceOfTruthCommand(
      commandKey: 'format_action_files',
      repo: repo,
    );

    if (results.exitCode != 0) {
      throw Exception(
          'The process exited with a non-zero code (${results.exitCode})\n${results.stdout}\n${results.stderr}');
    }

    print('✅ Formatted GitHub Action files.');
  }
}

Future<void> formatCode(
  Package package, {
  /// Throws if code is not already formatted properly.
  /// Useful for code analysis in CI.
  bool throwIfCodeChanged = false,
}) {
  return runProcessSucessfullyOrThrow(
      'fvm',
      [
        'dart',
        'format',
        if (throwIfCodeChanged) '--set-exit-if-changed',
        '.',
      ],
      workingDirectory: package.path);
}
