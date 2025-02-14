// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

Future<String> getCurrentCommitHash(ProcessRunner processRunner) async {
  final res = await processRunner.run(['git', 'rev-parse', 'HEAD']);
  if (res.stdout.isEmpty) {
    stderr.writeln(
      'Could not receive the current commit hash: (${res.exitCode}) ${res.stderr}.',
    );
    throw ToolExit(15);
  }
  final currentCommit = res.stdout;
  if (isVerbose) {
    stdout.writeln('Got current commit hash: $currentCommit');
  }
  return currentCommit;
}
