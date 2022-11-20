import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../privacy_policy_src.dart';

/// This will be added to the end of the privacy policy.
/// We use this for two purposes:
/// 1. Show the user the metadata of the privacy policy (version, last changes)
///
/// 2. If the [sectionName] is seen on screen (we arrive at the end of the
/// document) we automatically change the last section in the table of contents
/// to "currrently read", ignoring the chapter that would usually be
/// marked as "currently read" by using the [CurrentlyReadThreshold].
///
/// This is done because in some cases the last chapter of the privacy
/// policy is too short to scroll past the [CurrentlyReadThreshold]. In this
/// case the last chapter in the table of contents will never be highlighted.
/// For a nicer user experience we highlight the last section in the table of
/// contents if we arrive at the end of the document.
///
/// We use this weird workaround (observing if this specific chapter is
/// seen somewhere on screen regardless of the [CurrentlyReadThreshold])
/// because we can't observe the [ScrollController] to do a check like this:
/// ```dart
/// final isAtBottomOfDocument =
/// _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
/// ```
/// To implement the scrolling to a specific chapter we had to replace the
/// [ListView] with a [ScrollablePositionedList] used in the
/// [RelativeAnchorsMarkdown] widget internally to render the markdown text.
/// A [ScrollablePositionedList] internally uses two [ScrollController] that it
/// doesn't expose to the outside world:
/// https://github.com/google/flutter.widgets/issues/235
class PrivacyPolicyEndSection {
  final String sectionName;
  DocumentSectionId get sectionId =>
      DocumentSectionId(generateAnchorHash(sectionName));
  final String Function(PrivacyPolicy privacyPolicy) generateMarkdown;

  const PrivacyPolicyEndSection({
    @required this.sectionName,
    @required this.generateMarkdown,
  });

  factory PrivacyPolicyEndSection.metadata() {
    return PrivacyPolicyEndSection(
        sectionName: 'Metadaten',
        generateMarkdown: (privacyPolicy) => '''


---

##### Metadaten
Version: v${privacyPolicy.version}

Zuletzt aktualisiert: ${DateFormat('dd.MM.yyyy').format(privacyPolicy.lastChanged)}
''');
  }
}
