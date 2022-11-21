// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../privacy_policy_src.dart';

class PrivacyPolicyPageConfig {
  final CurrentlyReadThreshold threshold;

  /// Show a marker at [CurrentlyReadThreshold.position].
  final bool showDebugThresholdIndicator;
  final PrivacyPolicyEndSection endSection;

  factory PrivacyPolicyPageConfig({
    CurrentlyReadThreshold threshold,
    bool showDebugThresholdMarker,
    PrivacyPolicyEndSection endSection,
  }) {
    return PrivacyPolicyPageConfig._(
      threshold ?? CurrentlyReadThreshold(0.1),
      showDebugThresholdMarker ?? false,
      endSection ?? PrivacyPolicyEndSection.metadata(),
    );
  }
  PrivacyPolicyPageConfig._(
    this.threshold,
    this.showDebugThresholdIndicator,
    this.endSection,
  );
}
