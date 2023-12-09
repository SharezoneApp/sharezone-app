// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:sz_repo_cli/src/commands/src/check_license_headers_command.dart';
import 'package:sz_repo_cli/src/common/common.dart';

/// Add license headers to all files without one.
class AddLicenseHeadersCommand extends CommandBase {
  AddLicenseHeadersCommand(super.context);

  @override
  String get description =>
      'Add the necessary license headers to all files that do not have them yet.';

  @override
  String get name => 'add';

  @override
  Future<void> run() async {
    final results = await runLicenseHeaderCommand(
      processRunner,
      commandKey: 'add_license_headers',
      repo: repo,
    );

    if (results.exitCode != 0) {
      throw Exception(
          'The process exited with a non-zero code (${results.exitCode})\n${results.stdout}\n${results.stderr}');
    }

    stdout.writeln('Added license headers!');
  }
}
