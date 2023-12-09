// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/commands/src/format_command.dart';
import 'package:sz_repo_cli/src/common/common.dart';

import 'fix_comment_spacing_command.dart';
import 'pub_get_command.dart';

class AnalyzeCommand extends ConcurrentCommand {
  AnalyzeCommand(super.context);

  @override
  final String name = 'analyze';

  @override
  final String description = 'Analyzes all packages using package:tuneup.\n\n'
      'This command requires "pub" and "flutter" to be in your path.';

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 5);

  @override
  Future<void> runTaskForPackage(Package package) =>
      analyzePackage(processRunner, package);
}

Future<void> analyzePackage(
    ProcessRunner processRunner, Package package) async {
  await getPackage(processRunner, package);
  await _runDartAnalyze(processRunner, package);
  await formatCode(processRunner, package, throwIfCodeChanged: true);
  await _checkForCommentsWithBadSpacing(processRunner, package);
}

Future<void> _runDartAnalyze(
    ProcessRunner processRunner, Package package) async {
  await processRunner.run(
    ['fvm', 'dart', 'analyze', '--fatal-infos', '--fatal-warnings'],
    workingDirectory: package.location,
  );
}

Future<void> _checkForCommentsWithBadSpacing(
    ProcessRunner processRunner, Package package) async {
  if (doesPackageIncludeFilesWithBadCommentSpacing(package.path)) {
    throw Exception(
        'Package ${package.name} has comments with bad spacing. Fix them by running the `sz fix-comment-spacing` command.');
  }
  return;
}
