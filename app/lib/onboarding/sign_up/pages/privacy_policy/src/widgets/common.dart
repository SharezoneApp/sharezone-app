// TODO: Maybe split this file up into seperate smaller files?

import 'package:build_context/build_context.dart';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/theme.dart';

import '../privacy_policy_src.dart';
import 'privacy_policy_widgets.dart';

class PrivacyPolicyHeading extends StatelessWidget {
  const PrivacyPolicyHeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Datenschutzerklärung',
      style: Theme.of(context).textTheme.headline5.copyWith(
            fontSize: 24,
            color:
                isDarkThemeEnabled(context) ? primaryColor : Color(0xFF254D71),
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class PrivacyPolicySubheading extends StatelessWidget {
  const PrivacyPolicySubheading({
    Key key,
    @required this.entersIntoForceOn,
  }) : super(key: key);

  final DateTime entersIntoForceOn;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Diese aktualisierte Datenschutzerklärung tritt am',
        children: [
          TextSpan(
            text: ' ${DateFormat('dd.MM.yyyy').format(entersIntoForceOn)} ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'in Kraft.',
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ChangeAppearanceButton extends StatelessWidget {
  const ChangeAppearanceButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showDisplaySettingsDialog(context);
      },
      icon: Icon(Icons.display_settings),
      label: Text('Darstellung ändern'),
    );
  }
}

void showDisplaySettingsDialog(BuildContext context) {
  final themeSettings =
      Provider.of<PrivacyPolicyThemeSettings>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) => DisplaySettingsDialog(
      themeSettings: themeSettings,
    ),
  );
}

class DownloadAsPDFButton extends StatelessWidget {
  const DownloadAsPDFButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.pop();
      },
      icon: Icon(Icons.download),
      label: Text('Als PDF herunterladen'),
    );
  }
}

class ExpansionArrow extends StatelessWidget {
  const ExpansionArrow({
    Key key,
    @required this.expansionArrowTurns,
    @required this.onPressed,
  }) : super(key: key);

  final Animation<double> expansionArrowTurns;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: expansionArrowTurns,
      // TODO: When using the IconButton without constraints
      // the section is way bigger than the sections without
      // an arrow.
      // Consider looking at the sizes between devices/form
      // factors and see what looks best and what is also
      // accessible.
      // Right now we shrank the size below the minimum
      // accessbile size.
      child: IconButton(
        constraints: BoxConstraints(maxHeight: 30),
        padding: EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: const Icon(Icons.expand_more),
      ),
    );
  }
}

class SectionHighlight extends StatelessWidget {
  const SectionHighlight({
    Key key,
    @required this.child,
    @required this.shouldHighlight,
    @required this.onTap,
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  }) : super(key: key);

  final Widget child;
  final bool shouldHighlight;
  final VoidCallback onTap;
  final Color backgroundColor;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: ShapeDecoration(
        color: shouldHighlight
            ? (isDarkThemeEnabled(context)
                ? Colors.blue.shade800
                : Colors.lightBlue.shade100)
            : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        shape: shape,
      ),
      duration: Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}

class PrivacyPolicyText extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const PrivacyPolicyText({
    @required this.privacyPolicy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dependencies =
        Provider.of<PrivacyPolicyTextDependencies>(context, listen: false);
    final config = Provider.of<PrivacyPolicyPageConfig>(context, listen: false);
    final theme =
        Provider.of<PrivacyPolicyThemeSettings>(context, listen: false);
    final tocController =
        Provider.of<TableOfContentsController>(context, listen: false);

    return Stack(
      children: [
        RelativeAnchorsMarkdown(
          selectable: true,
          // TODO - Fix: Links (blue colored text) have bad contrast in dark mode
          styleSheet: MarkdownStyleSheet(
              h3: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w500),
              blockquoteDecoration: BoxDecoration(
                color: isDarkThemeEnabled(context)
                    ? Colors.blue.shade800.withOpacity(.6)
                    : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2.0),
              )),
          extensionSet: sharezoneMarkdownExtensionSet,
          anchorsController: dependencies.anchorsController,
          data: privacyPolicy.markdownText +
              config.endSection.generateMarkdown(privacyPolicy),
          onTapLink: (text, href, title) {
            if (href == null) return;
            if (href.startsWith('#')) {
              // TODO: Doesn't really make sense that we use the
              // "table of contents" controller here, does it?
              tocController.scrollTo(
                DocumentSectionId(
                  // Remove leading #
                  href.substring(1),
                ),
              );
              return;
            }
            launchURL(href, context: context);
          },
        ),
        if (theme.showDebugThresholdIndicator)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter
                    // We have to multiply the [config.threshold] with two so
                    // that it lines up with the real threshold on screen.
                    // I have absolutely no clue why though. If you dear reader
                    // know why then please replace this comment.
                    .add(Alignment(0, config.threshold.position * 2)),
                child: Divider(
                  color: Colors.red,
                  thickness: 2,
                  height: 0,
                ),
              ),
            ),
          )
      ],
    );
  }
}

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

// TODO: Can we remove this?
class PrivacyPolicyTextDependencies {
  final AnchorsController anchorsController;

  PrivacyPolicyTextDependencies({
    @required this.anchorsController,
  });
}

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

/// The threshold at which a [DocumentSection] is marked as "currently read"
/// when the [DocumentSectionHeadingPosition] intersects with [position].
///
/// For the exact behavior for when a section is marked as active see
/// [CurrentlyReadingSectionController] (and the tests).
///
/// This is encapsulated as a class for documentation purposes.
class CurrentlyReadThreshold {
  final double position;

  const CurrentlyReadThreshold(this.position)
      : assert(position >= 0.0 && position <= 1.0);

  bool intersectsOrIsPast(DocumentSectionHeadingPosition headingPosition) {
    return headingPosition.itemLeadingEdge <= position;
  }
}
