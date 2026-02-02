// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sz_repo_cli/src/common/common.dart';

class CleanGoldensCommand extends ConcurrentCommand {
  CleanGoldensCommand(super.context) {
    argParser.addFlag(
      'dry-run',
      help: 'Show what would be deleted, without deleting anything.',
      negatable: false,
      defaultsTo: false,
    );
  }

  @override
  String get description =>
      'Deletes all "failures/" folders under test_goldens directories. Useful for cleaning up after failed golden tests.';

  @override
  String get name => 'clean-goldens';

  bool get dryRun => argResults!['dry-run'] as bool;

  @override
  Stream<Package> get packagesToProcess =>
      super.packagesToProcess.where((p) => p.hasGoldenTestsDirectory);

  @override
  Future<void> runTaskForPackage(Package package) async {
    final testGoldensDir = fileSystem.directory(
      path.join(package.location.path, 'test_goldens'),
    );

    final failuresDirs = await _findAllFailuresDirs(testGoldensDir);

    if (failuresDirs.isEmpty) {
      return;
    }

    for (final dir in failuresDirs) {
      if (dryRun) {
        stdout.writeln('🧪 Would delete: ${dir.path}');
        continue;
      }

      try {
        await dir.delete(recursive: true);
        stdout.writeln('🗑️ Deleted: ${dir.path}');
      } catch (e) {
        stderr.writeln('❌ Failed to delete ${dir.path}: $e');
      }
    }
  }

  Future<List<Directory>> _findAllFailuresDirs(Directory root) async {
    final result = <Directory>[];

    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is Directory && path.basename(entity.path) == 'failures') {
        result.add(entity);
      }
    }

    return result;
  }
}
