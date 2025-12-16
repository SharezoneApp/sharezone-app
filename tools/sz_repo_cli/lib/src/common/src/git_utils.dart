// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:file/file.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

/// Checks if there are git changes in the given directory.
///
/// Returns a tuple where the first element is `true` if there are git changes
/// and the second element is the git diff.
Future<({bool hasChanges, String diffs})> hasGitChanges(
  ProcessRunner processRunner,
  Directory workingDirectory,
) async {
  final result = await processRunner.runCommand([
    'git',
    'diff',
    '--exit-code',
    workingDirectory.path,
  ], failOk: true);
  return (hasChanges: result.exitCode != 0, diffs: result.stdout);
}
