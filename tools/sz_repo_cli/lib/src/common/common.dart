// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/src/process_runner_utils.dart';

export 'src/command_base.dart';
export 'src/concurrent_command.dart';
export 'src/concurrent_package_task_runner.dart';
export 'src/context.dart';
export 'src/merge_with_value_stream_extension.dart';
export 'src/package.dart';
export 'src/package_timeout_exception.dart';
export 'src/process_runner_utils.dart';
export 'src/shared_args.dart';
export 'src/sharezone_repo.dart';
export 'src/to_utf8_string_extension.dart';
export 'src/tool_exit.dart';

/// Die globale Variable sollte in Zukunft entfernt und in einen Parameter
/// verwandelt werden, oder es sollte ein package wie package:logging benutzt
/// werden, fürs bessere Testen.
bool isVerbose = false;

Future<Directory> getProjectRootDirectory(
    FileSystem fs, ProcessRunner processRunner) async {
  final res = await processRunner.run(['git', 'rev-parse', '--show-toplevel']);
  final stdout = res.stdout;
  // Without [path.canonicalize] the path won't work on Windows as git returns
  // normal slashes instead the by Windows required backward slashes.
  final projectDirPath = path.canonicalize(stdout.trim());
  return fs.directory(projectDirPath);
}
