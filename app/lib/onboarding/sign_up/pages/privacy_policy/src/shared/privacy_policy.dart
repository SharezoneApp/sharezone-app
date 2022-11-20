import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:quiver/time.dart';

import '../privacy_policy_src.dart';

class PrivacyPolicy {
  final String markdownText;
  final IList<DocumentSection> tableOfContentSections;
  final String version;
  final DateTime lastChanged;
  // TODO: Use to display dialog at top of the screen.
  // What if it is in the past or today?
  final DateTime entersIntoForceOnOrNull;
  bool get hasNotYetEnteredIntoForce =>
      entersIntoForceOnOrNull != null &&
      entersIntoForceOnOrNull.isAfter(Clock().now());

  const PrivacyPolicy({
    @required this.markdownText,
    @required this.tableOfContentSections,
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
        other.lastChanged == lastChanged &&
        other.entersIntoForceOnOrNull == entersIntoForceOnOrNull;
  }

  @override
  int get hashCode {
    return markdownText.hashCode ^
        tableOfContentSections.hashCode ^
        version.hashCode ^
        lastChanged.hashCode ^
        entersIntoForceOnOrNull.hashCode;
  }
}
