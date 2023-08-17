import 'package:sz_repo_cli/src/common/src/run_process.dart';

Future<void> throwIfFvmIsNotInstalled() async {
  // Check if "which -s app-store-connect" returns 0.
  // If not, throw an exception.
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
