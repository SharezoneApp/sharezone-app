import 'dart:io';

import 'package:sz_repo_cli/src/common/src/run_process.dart';

/// Throws an exception if [command] is not installed.
///
/// Optionally, you can pass [instructionsToInstall] to throw an helpful
/// exception.
///
/// Currently, we skip this method for [Platform.]
Future<void> throwIfCommandIsNotInstalled({
  required String command,
  String? instructionsToInstall,
}) async {
  if (Platform.isWindows) {
    // We skip on Windows the check because "which -s" is not available for
    // Windows.
    return;
  }

  final result = await runProcess(
    'which',
    ['-s', command],
  );
  if (result.exitCode != 0) {
    String message = 'Command "$command" is not installed.';
    if (instructionsToInstall != null) {
      message += ' $instructionsToInstall';
    }

    throw Exception(message);
  }
}
