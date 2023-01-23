// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:test/test.dart';

void main() {
  test('Ensure source of truth yaml file exists', () async {
    final projectRoot = await getProjectRootDirectory();

    final repo = SharezoneRepo(projectRoot);

    /// If the file gets moved and the path for
    /// [repo.commandsSourceOfTruthYamlFile] not updated this will cause the CI
    /// pipeline to fail.
    expect(repo.commandsSourceOfTruthYamlFile.existsSync(), true,
        reason:
            'Commands source of truth file should exist at ${repo.commandsSourceOfTruthYamlFile.path}.\n'
            'If this file was moved on purpose then update the path in the Dart code.');
  });
}
