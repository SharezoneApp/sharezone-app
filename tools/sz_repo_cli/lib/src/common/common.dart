import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

export 'src/merge_with_value_stream_extension.dart';
export 'src/package.dart';
export 'src/package_timeout_exception.dart';
export 'src/run_and_stream.dart';
export 'src/shared_args.dart';
export 'src/sharezone_repo.dart';
export 'src/stream_to_utf8_string_extension.dart';
export 'src/tool_exit.dart';

/// Die globale Variable sollte in Zukunft entfernt und in einen Parameter
/// verwandelt werden, oder es sollte ein package wie package:logging benutzt
/// werden, fürs bessere Testen.
bool isVerbose = false;

Future<Directory> getProjectRootDirectory() async {
  final res = await Process.run('git', ['rev-parse', '--show-toplevel'],
      runInShell: false);
  final String stdout = res.stdout;
  if (stdout is! String) {
    print('Error: Could not get project root from git (output: ${res.stdout})');
    exit(1);
  }
  // Without [path.canonicalize] the path won't work on Windows as git returns
  // normal slashes instead the by Windows required backward slashes.
  final projectDirPath = path.canonicalize(stdout.trim());
  return Directory(projectDirPath);
}
