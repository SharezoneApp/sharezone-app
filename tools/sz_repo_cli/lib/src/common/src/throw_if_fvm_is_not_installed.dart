import 'package:sz_repo_cli/src/common/src/run_process.dart';

/// Throws exception if "fvm" if installed.
///
/// Uses "which -s fvm" to check if the command is installed. If "which -s"
/// returns 0, is the command installed.
Future<void> throwIfFvmIsNotInstalled() async {
  final result = await runProcess(
    'which',
    ['-s', 'fvm'],
  );
  if (result.exitCode != 0) {
    throw Exception(
      'FVM is not installed. Docs to install them: https://fvm.app/docs/getting_started/installation',
    );
  }
}
