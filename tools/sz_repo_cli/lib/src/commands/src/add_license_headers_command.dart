// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:args/command_runner.dart';

import 'package:sz_repo_cli/src/common/common.dart';

import 'check_license_headers_command.dart';

/// Add license headers to all files without one.
class AddLicenseHeadersCommand extends Command {
  AddLicenseHeadersCommand(this.repo);

  final SharezoneRepo repo;

  @override
  String get description =>
      'Add the necessary license headers to all files that do not have them yet.';

  @override
  String get name => 'add';

  @override
  Future<void> run() async {
    final results = await runLicenseHeaderCommand(
      commandKey: 'add_license_headers',
      repo: repo,
    );

    if (results.exitCode != 0) {
      throw Exception(
          'The process exited with a non-zero code (${results.exitCode})\n${results.stdout}\n${results.stderr}');
    }

    print('Added license headers!');
  }
}
