import 'package:file/file.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

class Context {
  final FileSystem fileSystem;
  final ProcessRunner processRunner;
  final SharezoneRepo repo;

  const Context({
    required this.fileSystem,
    required this.processRunner,
    required this.repo,
  });
}
