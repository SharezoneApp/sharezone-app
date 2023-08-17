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
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/run_source_of_truth_command.dart';

/// Check that all files have correct license headers.
class CheckLicenseHeadersCommand extends Command {
  CheckLicenseHeadersCommand(this.repo);

  final SharezoneRepo repo;

  @override
  String get description =>
      'Check that all files have the necessary license headers.';

  @override
  String get name => 'check';

  @override
  Future<void> run() async {
    final results = await runLicenseHeaderCommand(
      commandKey: 'check_license_headers',
      repo: repo,
    );

    if (results.exitCode != 0) {
      print("The following files don't have a correct license header:");
      print(results.stdout);
      return;
    }

    print('All files have correct license headers.');
  }
}

/// Run a license header command via a key.
///
/// The key can be seen in the [repo.commandsSourceOfTruthYamlFile] file.
Future<ProcessResult> runLicenseHeaderCommand({
  required String commandKey,
  required SharezoneRepo repo,
}) {
  return runSourceOfTruthCommand(
    commandKey: commandKey,
    repo: repo,
    argumentsToAppend: [repo.location.path],
  );
}
