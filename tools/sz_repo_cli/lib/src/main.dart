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
import 'package:file/local.dart';
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
  const fileSystem = LocalFileSystem();

  ProcessRunner processRunner = ProcessRunner();
  final verbose = args.contains('-v') || args.contains('--verbose');
  final projectRoot = await getProjectRootDirectory(fileSystem, processRunner);

  processRunner = ProcessRunner(
    defaultWorkingDirectory: projectRoot,
    printOutputDefault: verbose,
  );

  final repo = SharezoneRepo(fileSystem, projectRoot);
  final context = Context(
    fileSystem: fileSystem,
    processRunner: processRunner,
    repo: repo,
  );

  final commandRunner = CommandRunner('pub global run sz_repo_cli',
      'Productivity utils for everything Sharezone.')
    ..addCommand(AnalyzeCommand(context))
    ..addCommand(TestCommand(context))
    ..addCommand(FormatCommand(context))
    ..addCommand(ExecCommand(context))
    ..addCommand(DoStuffCommand(context))
    ..addCommand(FixCommentSpacingCommand(context))
    ..addCommand(PubCommand()..addSubcommand(PubGetCommand(context)))
    ..addCommand(LicenseHeadersCommand()
      ..addSubcommand(CheckLicenseHeadersCommand(context))
      ..addSubcommand(AddLicenseHeadersCommand(context)))
    ..addCommand(DeployCommand()
      ..addSubcommand(DeployWebAppCommand(context))
      ..addSubcommand(DeployIosCommand(context))
      ..addSubcommand(DeployMacOsCommand(context))
      ..addSubcommand(DeployAndroidCommand(context)))
    ..addCommand(BuildCommand()
      ..addSubcommand(BuildAndroidCommand(context))
      ..addSubcommand(BuildMacOsCommand(context))
      ..addSubcommand(BuildWebCommand(context))
      ..addSubcommand(BuildIosCommand(context)))
    ..addCommand(
        BuildRunnerCommand()..addSubcommand(BuildRunnerBuild(context)));

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
