// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/pages/settings/changelog/change.dart';

class ChangeView {
  String? version;
  List<String>? newFeatures;
  List<String>? improvements;
  List<String>? fixes;
  bool? isNewerThanCurrentVersion;

  ChangeView({
    required this.version,
    this.newFeatures = const [],
    this.improvements = const [],
    this.fixes = const [],
    this.isNewerThanCurrentVersion = false,
  });

  ChangeView.fromModel(Change change, Version currentVersion) {
    version = change.version.name;
    newFeatures = change.newFeatures;
    improvements = change.improvements;
    fixes = change.fixes;
    isNewerThanCurrentVersion = change.version > currentVersion;
  }
}
