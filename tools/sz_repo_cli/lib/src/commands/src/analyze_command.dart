// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sz_repo_cli/src/commands/src/format_command.dart';
import 'package:sz_repo_cli/src/common/common.dart';

import 'fix_comment_spacing_command.dart';
import 'pub_get_command.dart';

class AnalyzeCommand extends ConcurrentCommand {
  AnalyzeCommand(SharezoneRepo repo) : super(repo);

  @override
  final String name = 'analyze';

  @override
  final String description = 'Analyzes all packages using package:tuneup.\n\n'
      'This command requires "pub" and "flutter" to be in your path.';

  @override
  Duration get defaultPackageTimeout => const Duration(minutes: 5);

  @override
  Future<void> runTaskForPackage(Package package) => analyzePackage(package);
}

Future<void> analyzePackage(Package package) async {
  await getPackage(package);
  await _runDartAnalyze(package);
  await formatCode(package, throwIfCodeChanged: true);
  await _checkForCommentsWithBadSpacing(package);
}

Future<void> _runDartAnalyze(Package package) {
  return runProcessSuccessfullyOrThrow(
      'fvm', ['dart', 'analyze', '--fatal-infos', '--fatal-warnings'],
      workingDirectory: package.path);
}

Future<void> _checkForCommentsWithBadSpacing(Package package) async {
  if (doesPackageIncludeFilesWithBadCommentSpacing(package.path)) {
    throw Exception(
        'Package ${package.name} has comments with bad spacing. Fix them by running the `sz fix-comment-spacing` command.');
  }
  return;
}
