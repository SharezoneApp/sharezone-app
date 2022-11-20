import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_v2.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/table_of_contents_controller.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/widgets/common.dart';

// TODO: Add randomness depending on env seed?
PrivacyPolicy privacyPolicyWith({
  List<DocumentSection> tableOfContentSections,
  String markdown,
}) {
  return PrivacyPolicy(
    lastChanged: DateTime(2022, 03, 04),
    tableOfContentSections: tableOfContentSections.toIList() ??
        v2PrivacyPolicy.tableOfContentSections,
    version: '2.0.0',
    markdownText: markdown ?? v2PrivacyPolicy.markdownText,
    entersIntoForceOnOrNull: null,
  );
}
