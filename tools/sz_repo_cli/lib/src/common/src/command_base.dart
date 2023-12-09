// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
