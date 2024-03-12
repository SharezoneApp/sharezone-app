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
import 'package:sz_repo_cli/src/commands/src/build_app_android_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_app_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_app_ios_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_app_macos_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_console_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_runner_build_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_runner_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_app_web_command.dart';
import 'package:sz_repo_cli/src/commands/src/build_website_command.dart';
import 'package:sz_repo_cli/src/commands/src/check_license_headers_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_app_android_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_app_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_app_ios_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_app_macos_command.dart';
import 'package:sz_repo_cli/src/commands/src/deploy_website_command.dart';
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

  final commandRunner =
      CommandRunner('sz', 'Sharezone CLI, a tool for Sharezone developers.')
        ..addCommand(AnalyzeCommand(context))
        ..addCommand(TestCommand(context))
        ..addCommand(FormatCommand(context))
        ..addCommand(ExecCommand(context))
        ..addCommand(DoStuffCommand(context))
        ..addCommand(FixCommentSpacingCommand(context))
        ..addCommand(PickCodemagicGoldens(context))
        ..addCommand(PubCommand()..addSubcommand(PubGetCommand(context)))
        ..addCommand(LicenseHeadersCommand()
          ..addSubcommand(CheckLicenseHeadersCommand(context))
          ..addSubcommand(AddLicenseHeadersCommand(context)))
        ..addCommand(DeployCommand()
          ..addSubcommand(DeployAppCommand(context)
            ..addSubcommand(DeployAppWebCommand(context))
            ..addSubcommand(DeployAppIosCommand(context))
            ..addSubcommand(DeployAppMacOsCommand(context))
            ..addSubcommand(DeployAndroidCommand(context)))
          ..addSubcommand(DeployWebsiteCommand(context)))
        ..addCommand(BuildCommand()
          ..addSubcommand(BuildAppCommand(context)
            ..addSubcommand(BuildAppAndroidCommand(context))
            ..addSubcommand(BuildAppMacOsCommand(context))
            ..addSubcommand(BuildAppWebCommand(context))
            ..addSubcommand(BuildAppIosCommand(context)))
          ..addSubcommand(BuildConsoleCommand(context))
          ..addSubcommand(BuildWebsiteCommand(context)))
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
