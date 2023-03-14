// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// TODO: Maybe split this file up into seperate smaller files?

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/additional.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

class PrivacyPolicyHeading extends StatelessWidget {
  const PrivacyPolicyHeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Datenschutzerklärung',
      style: Theme.of(context).textTheme.headlineSmall.copyWith(
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
    this.enabled = true,
  }) : super(key: key);

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: enabled
          ? () {
              final downloadUrl = Provider.of<Uri>(context, listen: false);
              launchUrl(downloadUrl);
            }
          : null,
      style: _buttonStyle,
      icon: Icon(Icons.download),
      label: Text('Als PDF herunterladen'),
    );
  }
}

final _buttonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.disabled) ? Colors.grey : null),
);

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
    final anchorController =
        Provider.of<AnchorController>(context, listen: false);
    final config = Provider.of<PrivacyPolicyPageConfig>(context, listen: false);
    final theme =
        Provider.of<PrivacyPolicyThemeSettings>(context, listen: false);
    final documentController =
        Provider.of<DocumentController>(context, listen: false);

    return Stack(
      children: [
        RelativeAnchorsMarkdown(
          selectable: true,
          // TODO - Fix: Links (blue colored text) have bad contrast in dark mode
          styleSheet: MarkdownStyleSheet(
              h3: Theme.of(context)
                  .textTheme
                  .titleMedium
                  .copyWith(fontWeight: FontWeight.w500),
              blockquoteDecoration: BoxDecoration(
                color: isDarkThemeEnabled(context)
                    ? Colors.blue.shade800.withOpacity(.6)
                    : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2.0),
              )),
          extensionSet: sharezoneMarkdownExtensionSet,
          anchorController: anchorController,
          data: privacyPolicy.markdownText +
              config.endSection.generateMarkdown(privacyPolicy),
          onTapLink: (text, href, title) {
            if (href == null) return;
            if (href.startsWith('#')) {
              documentController.scrollToDocumentSection(
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

class PrivacyTextLoadingPlaceholder extends StatelessWidget {
  const PrivacyTextLoadingPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GrayShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textLine(context, widthFactor: .7, height: 40),
            ..._textLines(context, 5, widthFactor: 1),
            SizedBox(height: 20),
            _textLine(context, widthFactor: .65, height: 30),
            ..._textLines(context, 1, widthFactor: .5, height: 20),
            SizedBox(height: 5),
            ..._textLines(context, 3, widthFactor: 1, height: 20),
            ..._textLines(context, 1, widthFactor: .7, height: 20),
            SizedBox(height: 20),
            _textLine(context, widthFactor: .65, height: 30),
            ..._textLines(context, 2, widthFactor: 1),
            SizedBox(height: 10),
            ..._textLines(context, 5, widthFactor: .8),
            SizedBox(height: 10),
            ..._textLines(context, 10, widthFactor: 1),
            ..._textLines(context, 10, widthFactor: .8),
          ],
        ),
      ),
    );
  }

  List<Widget> _textLines(BuildContext context, int n,
      {double widthFactor = 1, double height = 25}) {
    final lines = <Widget>[];
    for (var i = 0; i < n; i++) {
      lines.addAll([
        SizedBox(height: 10),
        _textLine(context, widthFactor: widthFactor, height: height),
      ]);
    }
    return lines;
  }

  Widget _textLine(
    BuildContext context, {
    @required double widthFactor,
    @required double height,
  }) {
    return SizedBox(
      height: height,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: ColoredBox(color: Theme.of(context).canvasColor),
      ),
    );
  }
}

class OpenTocBottomSheetButton extends StatelessWidget {
  const OpenTocBottomSheetButton({
    this.enabled = true,
  }) : super(key: const ValueKey('open-toc-bottom-sheet-button-E2E'));

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TextButton(
        style: _buttonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Inhaltsverzeichnis'),
            Icon(Icons.expand_less),
          ],
        ),
        onPressed: enabled
            ? () {
                showTableOfContentsBottomSheet(context);
              }
            : null,
      ),
    );
  }
}

class LoadingFailureMainAreaContent extends StatelessWidget {
  const LoadingFailureMainAreaContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 60),
            SizedBox(height: 12),
            Text(
              'Fehler beim Laden der Datenschutzerklärung',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              'Versuche es erneut oder lade dir die PDF-Version der Datenschutzerklärung herunter.',
              textAlign: TextAlign.center,
            ),
            Text(
              'Stelle sicher, dass du eine funktionierende Internetverbindung hast.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            TextButton.icon(
                key: ValueKey('retry-loading-button-E2E'),
                icon: Icon(Icons.refresh),
                label: Text('Erneut versuchen'),
                onPressed: () {}),
            SizedBox(height: 7),
            DownloadAsPDFButton(enabled: true)
          ],
        )),
      ),
    );
  }
}

extension PrivacyPolicyVisualDensity on BuildContext {
  VisualDensity get ppVisualDensity =>
      watch<PrivacyPolicyThemeSettings>().visualDensitySetting.visualDensity;
}

class PrivacyPolicyLoadingState {
  final AsyncSnapshot<PrivacyPolicy> privacyPolicySnapshot;

  PrivacyPolicy get privacyPolicyOrNull => privacyPolicySnapshot.data;

  // TODO: I think this might be broken if we return null?
  bool get isSuccessful => privacyPolicySnapshot.hasData;
  bool get isError => privacyPolicySnapshot.hasError;
  bool get isLoading => !isSuccessful && !isError;

  PrivacyPolicyLoadingState(this.privacyPolicySnapshot);

  T when<T>(
      {T Function(dynamic error, StackTrace stackTrace) onError,
      T Function() onLoading,
      T Function(PrivacyPolicy) onSuccess}) {
    if (privacyPolicySnapshot.hasError) {
      return onError?.call(
          privacyPolicySnapshot.error, privacyPolicySnapshot.stackTrace);
    }
    if (!privacyPolicySnapshot.hasData) {
      return onLoading?.call();
    }
    return onSuccess?.call(privacyPolicySnapshot.data);
  }
}
