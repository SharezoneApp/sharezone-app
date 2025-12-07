// Copyright (c) 2024 Sharezone UG (haftungsbeschr\u00e4nkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/common/common.dart';

/// Generates localization files and adds license headers.
class L10nCommand extends CommandBase {
  L10nCommand(super.context);

  @override
  String get name => 'l10n';

  @override
  String get description =>
      'Generates localization files and adds license headers.';

  @override
  Future<void> run() async {
    final l10nDir = repo.location
        .childDirectory('lib')
        .childDirectory('sharezone_localizations');

    await processRunner.runCommand([
      'flutter',
      'gen-l10n',
    ], workingDirectory: l10nDir);
    await processRunner.runCommand([
      'addlicense',
      '-c',
      'Sharezone UG (haftungsbeschränkt)',
      '-f',
      '../../header_template.txt',
      '.',
    ], workingDirectory: l10nDir);
  }
}
