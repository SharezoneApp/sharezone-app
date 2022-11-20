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
