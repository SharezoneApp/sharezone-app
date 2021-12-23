import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

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
    ..addCommand(DoStuffCommand(repo))
    ..addCommand(FixCommentSpacingCommand(repo))
    ..addCommand(PubCommand()..addSubcommand(PubGetCommand(repo)))
    ..addCommand(DeployCommand()..addSubcommand(DeployWebAppCommand(repo)));

  await commandRunner.run(args).catchError((Object e) {
    final ToolExit toolExit = e;
    exit(toolExit.exitCode);
  }, test: (Object e) => e is ToolExit)
      // Ansonsten wird die StackTrace noch zusätzlich ausgeprintet, was die Benutzung
      // unschön macht.
      .catchError((Object e) {
    print(e);
  }, test: (e) => e is UsageException);
}
