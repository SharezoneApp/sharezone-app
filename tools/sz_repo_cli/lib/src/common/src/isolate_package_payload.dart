// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2-or-later

import 'package:file/local.dart';
import 'package:sz_repo_cli/src/common/src/package.dart';

Map<String, Object?> packageToPayload(Package package) {
  return {
    'path': package.location.path,
    'name': package.name,
    'version': package.version,
    'type': package.type.index,
    'hasTestDirectory': package.hasTestDirectory,
    'hasGoldenTestsDirectory': package.hasGoldenTestsDirectory,
    'hasBuildRunnerDependency': package.hasBuildRunnerDependency,
  };
}

Package packageFromPayload(Map<String, Object?> payload) {
  return Package(
    location: const LocalFileSystem().directory(payload['path'] as String),
    name: payload['name'] as String,
    version: payload['version'] as String?,
    type: PackageType.values[payload['type'] as int],
    hasTestDirectory: payload['hasTestDirectory'] as bool,
    hasGoldenTestsDirectory: payload['hasGoldenTestsDirectory'] as bool,
    hasBuildRunnerDependency: payload['hasBuildRunnerDependency'] as bool,
  );
}
