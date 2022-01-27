// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';

class Release {
  final Version version;
  final DateTime releaseDate;

  Release({
    @required this.version,
    @required this.releaseDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Release &&
        other.version == version &&
        other.releaseDate == releaseDate;
  }

  @override
  int get hashCode => version.hashCode ^ releaseDate.hashCode;
}
