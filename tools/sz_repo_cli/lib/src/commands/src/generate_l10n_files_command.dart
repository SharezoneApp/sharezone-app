// Copyright (c) 2024 Sharezone UG (haftungsbeschr\u00e4nkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:file/file.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/throw_if_command_is_not_installed.dart';

/// Generates localization files and adds license headers.
class GenerateL10nFilesCommand extends CommandBase {
  GenerateL10nFilesCommand(super.context);

  @override
  String get name => 'generate';

  @override
  String get description =>
      'Generates localization files and adds license headers.';

  @override
  List<String> get aliases => ['g'];

  @override
  Future<void> run() async {
    _throwIfArbsortIsNotInstalled();

    final l10nDir = repo.location
        .childDirectory('lib')
        .childDirectory('sharezone_localizations');

    // First, we sort the arb files. This must be done before generating the
    // localization files, as `flutter gen-l10n` uses the sorted arb files for
    // generation.
    await _sortArbFiles(l10nDir);

    // Then, we generate the l10n files.
    await _generateL10nFiles(l10nDir);

    // Because "flutter gen-l10n" removes the license header, we have to add
    // them again.
    await _addLicenseHeader(l10nDir);
  }

  void _throwIfArbsortIsNotInstalled() {
    throwIfCommandIsNotInstalled(
      processRunner,
      command: 'arbsort',
      instructionsToInstall:
          'Install arbsort via Homebrew ("brew tap leancodepl/arbsort && brew install arbsort") or Go ("go install github.com/leancodepl/arbsort@latest")',
    );
  }

  Future<void> _generateL10nFiles(Directory l10nDir) async {
    await processRunner.runCommand([
      'flutter',
      'gen-l10n',
    ], workingDirectory: l10nDir);
  }

  Future<void> _sortArbFiles(Directory l10nDir) async {
    final arbFilesDir = l10nDir.childDirectory('l10n');

    final arbFiles = arbFilesDir.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.arb'),
    );
    await Future.wait([
      for (final arbFile in arbFiles)
        processRunner.runCommand(['arbsort', arbFile.path]),
    ]);
  }

  Future<void> _addLicenseHeader(Directory l10nDir) async {
    await processRunner.runCommand([
      'addlicense',
      '-c',
      'Sharezone UG (haftungsbeschränkt)',
      '-f',
      '../../header_template.txt',
      '.',
    ], workingDirectory: l10nDir);
  }
}
