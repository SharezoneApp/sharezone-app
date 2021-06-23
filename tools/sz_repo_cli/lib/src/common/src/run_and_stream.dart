import 'dart:io';

import '../common.dart';

Future<int> runAndStream(String executable, List<String> args,
    {Directory workingDir, bool exitOnError = false}) async {
  final process = await Process.start(executable, args,
      workingDirectory: workingDir?.path, runInShell: true);
  process.stdout.listen(stdout.add);
  process.stderr.listen(stderr.add);
  if (exitOnError && await process.exitCode != 0) {
    final error = _getErrorString(executable, args, workingDir: workingDir);
    print('$error See above for details.');
    throw ToolExit(await process.exitCode);
  }
  return process.exitCode;
}

String _getErrorString(String executable, List<String> args,
    {Directory workingDir}) {
  final workdir = workingDir == null ? '' : ' in ${workingDir.path}';
  return 'ERROR: Unable to execute "$executable ${args.join(' ')}"$workdir.';
}
