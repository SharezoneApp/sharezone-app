// TODO: Maybe split this file up into seperate smaller files?

import 'package:build_context/build_context.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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

    return RelativeAnchorsMarkdown(
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
      itemScrollController: dependencies.itemScrollController,
      itemPositionsListener: dependencies.itemPositionsListener,
      anchorsController: dependencies.anchorsController,
// TODO: Replace this temporary placeholder with the real thing
      data: '''
${privacyPolicy.markdownText}

---

##### Metadaten
Version: v${privacyPolicy.version}

Zuletzt aktualisiert: 06.01.2022 
''',
      onTapLink: (text, href, title) {
        if (href == null) return;
        if (href.startsWith('#')) {
          dependencies.anchorsController.scrollToAnchor(
            // Remove leading #
            href.substring(1),
          );
          return;
        }
        launchURL(href, context: context);
      },
    );
  }
}

class PrivacyPolicy {
  final String markdownText;
  final List<DocumentSection> tableOfContentSections;
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

class PrivacyPolicyTextDependencies {
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final AnchorsController anchorsController;

  PrivacyPolicyTextDependencies({
    @required this.itemScrollController,
    @required this.itemPositionsListener,
    @required this.anchorsController,
  });
}
