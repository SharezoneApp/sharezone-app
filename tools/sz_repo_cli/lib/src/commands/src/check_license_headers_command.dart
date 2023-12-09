// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/run_source_of_truth_command.dart';

/// Check that all files have correct license headers.
class CheckLicenseHeadersCommand extends CommandBase {
  CheckLicenseHeadersCommand(super.context);

  @override
  String get description =>
      'Check that all files have the necessary license headers.';

  @override
  String get name => 'check';

  @override
  Future<void> run() async {
    final results = await runLicenseHeaderCommand(
      processRunner,
      commandKey: 'check_license_headers',
      repo: repo,
    );

    if (results.exitCode != 0) {
      stdout
          .writeln("The following files don't have a correct license header:");
      stdout.writeln(results.stdout);
      return;
    }

    stdout.writeln('All files have correct license headers.');
  }
}

/// Run a license header command via a key.
///
/// The key can be seen in the [repo.commandsSourceOfTruthYamlFile] file.
Future<ProcessRunnerResult> runLicenseHeaderCommand(
  ProcessRunner processRunner, {
  required String commandKey,
  required SharezoneRepo repo,
}) {
  return runSourceOfTruthCommand(
    processRunner,
    commandKey: commandKey,
    repo: repo,
    argumentsToAppend: [repo.location.path],
  );
}
