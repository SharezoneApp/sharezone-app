// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
