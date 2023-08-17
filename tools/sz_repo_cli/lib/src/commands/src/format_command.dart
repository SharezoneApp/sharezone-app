// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/throw_if_fvm_is_not_installed.dart';

class FormatCommand extends ConcurrentCommand {
  FormatCommand(SharezoneRepo repo) : super(repo);

  @override
  final String name = 'format';

  @override
  final String description = 'Formats packages via "dart format".\n'
      'Does not fail if packages are not formatted properly.';

  @override
  Duration get defaultPackageTimeout => Duration(minutes: 3);

  @override
  Future<void> runTaskForPackage(Package package) async {
    await throwIfFvmIsNotInstalled();
    await _throwIfPrettierIsNotInstalled();

    await formatCode(package);
  }

  Future<void> _throwIfPrettierIsNotInstalled() async {
    // Check if "which -s app-store-connect" returns 0.
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

  Future<void> _formatActionFiles() async {}
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
