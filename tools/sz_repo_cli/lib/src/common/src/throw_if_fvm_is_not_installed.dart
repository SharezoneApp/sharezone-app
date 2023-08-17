// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/common/src/run_process.dart';

/// Throws exception if "fvm" if installed.
///
/// Uses "which -s fvm" to check if the command is installed. If "which -s"
/// returns 0, is the command installed.
Future<void> throwIfFvmIsNotInstalled() async {
  final result = await runProcess(
    'which',
    ['-s', 'fvm'],
  );
  if (result.exitCode != 0) {
    throw Exception(
      'FVM is not installed. Docs to install them: https://fvm.app/docs/getting_started/installation',
    );
  }
}
