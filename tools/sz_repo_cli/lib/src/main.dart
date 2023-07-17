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
import 'package:path/path.dart' as p;
import 'package:sz_repo_cli/src/commands/src/add_license_headers_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_android_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_web_command.dart';
import 'package:sz_repo_cli/src/commands/src/check_license_headers_command.dart';
import 'package:sz_repo_cli/src/commands/src/format_command.dart';
import 'package:sz_repo_cli/src/commands/src/license_headers_command.dart';

import 'commands/commands.dart';
import 'common/common.dart';

Future<void> main(List<String> args) async {
  final projectRoot = await getProjectRootDirectory();
  final packagesDir = Directory(p.join(projectRoot.path, 'lib'));

  if (!packagesDir.existsSync()) {
    print('Error: Cannot find a "lib" sub-directory');
    exit(1);
  }

  final repo = SharezoneRepo(projectRoot);

  final commandRunner = CommandRunner('pub global run sz_repo_cli',
      'Productivity utils for everything Sharezone.')
    ..addCommand(AnalyzeCommand(repo))
    ..addCommand(LocateSharezoneAppFlutterDirectoryCommand())
    ..addCommand(TestCommand(repo))
    ..addCommand(FormatCommand(repo))
    ..addCommand(DoStuffCommand(repo))
    ..addCommand(FixCommentSpacingCommand(repo))
    ..addCommand(PubCommand()..addSubcommand(PubGetCommand(repo)))
    ..addCommand(LicenseHeadersCommand()
      ..addSubcommand(CheckLicenseHeadersCommand(repo))
      ..addSubcommand(AddLicenseHeadersCommand(repo)))
    ..addCommand(DeployCommand()..addSubcommand(DeployWebAppCommand(repo)))
    ..addCommand(BuildCommand()
      ..addSubcommand(BuildAndroidCommand(repo))
      ..addSubcommand(BuildWebCommand(repo)));

  await commandRunner.run(args).catchError((Object e) {
    final toolExit = e as ToolExit;
    exit(toolExit.exitCode);
  }, test: (Object e) => e is ToolExit)
      // Ansonsten wird die StackTrace noch zusätzlich ausgeprintet, was die Benutzung
      // unschön macht.
      .catchError((Object e) {
    print(e);
  }, test: (e) => e is UsageException);
}
