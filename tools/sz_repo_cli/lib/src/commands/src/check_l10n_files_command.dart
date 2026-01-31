// Copyright (c) 2024 Sharezone UG (haftungsbeschr\u00e4nkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/git_utils.dart';

class CheckL10nFilesCommand extends CommandBase {
  CheckL10nFilesCommand(super.context);

  @override
  String get name => 'check';

  @override
  String get description =>
      'Checks if the localization files are up to date. This command is intended to be used in CI.';

  @override
  Future<void> run() async {
    await processRunner.runCommand(['sz', 'l10n', 'generate']);

    final l10nPackageDirectory = repo.location.childDirectory(
      'lib/sharezone_localizations',
    );

    final (:hasChanges, :diffs) = await hasGitChanges(
      processRunner,
      l10nPackageDirectory,
    );
    if (hasChanges) {
      stdout.write(
        'Localization files are not up to date. Run `sz l10n generate` to update them.\n\n$diffs',
      );
      exitCode = 1;
    }
  }
}
