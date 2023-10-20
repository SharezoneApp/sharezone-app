// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/src/process_runner_utils.dart';

/// Throws an exception if [command] is not installed.
///
/// Optionally, you can pass [instructionsToInstall] to throw an helpful
/// exception.
///
/// Currently, we skip this method for [Platform.isWindows] because "which -s"
/// is not available for Windows.
Future<void> throwIfCommandIsNotInstalled(
  ProcessRunner processRunner, {
  required String command,
  String? instructionsToInstall,
}) async {
  if (Platform.isWindows) {
    // We skip on Windows the check because "which -s" is not available for
    // Windows.
    return;
  }

  final result = await processRunner.run(
    ['which', '-s', command],
    failOk: true,
  );
  if (result.exitCode != 0) {
    String message = 'Command "$command" is not installed.';
    if (instructionsToInstall != null) {
      message += ' $instructionsToInstall';
    }

    throw Exception(message);
  }
}
