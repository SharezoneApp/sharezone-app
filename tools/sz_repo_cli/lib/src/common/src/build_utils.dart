// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/common/common.dart';

/// Returns the build name for the app and adds the stage.
///
/// Example:
///  * Stage is `beta`: `1.0.0-beta` -> `1.0.0-beta`
String getBuildNameWithStage(Package package, String stage) {
  final version = package.version;
  if (version == null) {
    throw Exception(
      'Package "${package.name}" has no version. Please add a version.',
    );
  }

  final versionWithoutBuildNumber = version.split('+').first;
  return '$versionWithoutBuildNumber-$stage';
}
