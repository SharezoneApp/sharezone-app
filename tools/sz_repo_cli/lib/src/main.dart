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
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/commands/src/add_license_headers_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_android_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_ios_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_macos_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_runner_build_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_runner_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_web_command.dart';
import 'package:sz_repo_cli/src/commands/src/check_license_headers_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_android_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_ios_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_macos_command.dart';
import 'package:sz_repo_cli/src/commands/src/format_command.dart';
import 'package:sz_repo_cli/src/commands/src/license_headers_command.dart';

import 'commands/commands.dart';
import 'common/common.dart';

Future<void> main(List<String> args) async {
  ProcessRunner processRunner = ProcessRunner();
  final verbose = args.contains('-v') || args.contains('--verbose');
  final projectRoot = await getProjectRootDirectory(processRunner);

  processRunner = ProcessRunner(
    defaultWorkingDirectory: projectRoot,
    printOutputDefault: verbose,
  );

  final packagesDir = Directory(p.join(projectRoot.path, 'lib'));

  if (!packagesDir.existsSync()) {
    stderr.writeln('Error: Cannot find a "lib" sub-directory');
    exit(1);
  }

  final repo = SharezoneRepo(projectRoot);

  final commandRunner = CommandRunner('pub global run sz_repo_cli',
      'Productivity utils for everything Sharezone.')
    ..addCommand(AnalyzeCommand(processRunner, repo))
    ..addCommand(TestCommand(processRunner, repo))
    ..addCommand(FormatCommand(processRunner, repo))
    ..addCommand(ExecCommand(processRunner, repo))
    ..addCommand(DoStuffCommand(repo))
    ..addCommand(FixCommentSpacingCommand(repo))
    ..addCommand(
        PubCommand()..addSubcommand(PubGetCommand(processRunner, repo)))
    ..addCommand(LicenseHeadersCommand()
      ..addSubcommand(CheckLicenseHeadersCommand(processRunner, repo))
      ..addSubcommand(AddLicenseHeadersCommand(processRunner, repo)))
    ..addCommand(DeployCommand()
      ..addSubcommand(DeployWebAppCommand(processRunner, repo))
      ..addSubcommand(DeployIosCommand(processRunner, repo))
      ..addSubcommand(DeployMacOsCommand(processRunner, repo))
      ..addSubcommand(DeployAndroidCommand(processRunner, repo)))
    ..addCommand(BuildCommand()
      ..addSubcommand(BuildAndroidCommand(processRunner, repo))
      ..addSubcommand(BuildMacOsCommand(processRunner, repo))
      ..addSubcommand(BuildWebCommand(processRunner, repo))
      ..addSubcommand(BuildIosCommand(processRunner, repo)))
    ..addCommand(BuildRunnerCommand()
      ..addSubcommand(BuildRunnerBuild(processRunner, repo)));

  await commandRunner.run(args).catchError((Object e) {
    final toolExit = e as ToolExit;
    exit(toolExit.exitCode);
  }, test: (Object e) => e is ToolExit)
      // Ansonsten wird die StackTrace noch zusätzlich ausgeprintet, was die Benutzung
      // unschön macht.
      .catchError((Object e) {
    stdout.writeln(e);
  }, test: (e) => e is UsageException);
}
