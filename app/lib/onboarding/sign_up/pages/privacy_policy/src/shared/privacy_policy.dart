// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:quiver/time.dart';

import '../privacy_policy_src.dart';

class PrivacyPolicy {
  final String markdownText;
  final IList<DocumentSection> tableOfContentSections;
  final String version;
  final Uri downloadUrl;
  final DateTime lastChanged;
  final DateTime entersIntoForceOnOrNull;
  bool get hasNotYetEnteredIntoForce =>
      entersIntoForceOnOrNull != null &&
      entersIntoForceOnOrNull.isAfter(Clock().now());

  const PrivacyPolicy({
    @required this.markdownText,
    @required this.tableOfContentSections,
    @required this.downloadUrl,
    @required this.version,
    @required this.lastChanged,
    this.entersIntoForceOnOrNull,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PrivacyPolicy &&
        other.markdownText == markdownText &&
        listEquals(other.tableOfContentSections, tableOfContentSections) &&
        other.version == version &&
        other.downloadUrl == downloadUrl &&
        other.lastChanged == lastChanged &&
        other.entersIntoForceOnOrNull == entersIntoForceOnOrNull;
  }

  @override
  int get hashCode {
    return markdownText.hashCode ^
        tableOfContentSections.hashCode ^
        version.hashCode ^
        downloadUrl.hashCode ^
        lastChanged.hashCode ^
        entersIntoForceOnOrNull.hashCode;
  }
}
