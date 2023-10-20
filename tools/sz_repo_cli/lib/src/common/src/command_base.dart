import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

abstract class CommandBase extends Command {
  final Context context;
  ProcessRunner get processRunner => context.processRunner;
  SharezoneRepo get repo => context.repo;
  FileSystem get fileSystem => context.fileSystem;

  CommandBase(this.context) {
    argParser.addVerboseFlag();
  }
}
