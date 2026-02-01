// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

class PrivacyPolicyHeading extends StatelessWidget {
  const PrivacyPolicyHeading({super.key, required this.headingText});

  final String headingText;

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
        fontSize: 24,
        color:
            Theme.of(context).isDarkTheme
                ? primaryColor
                : const Color(0xFF254D71),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PrivacyPolicySubheading extends StatelessWidget {
  const PrivacyPolicySubheading({super.key, required this.entersIntoForceOn});

  final DateTime? entersIntoForceOn;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat.yMd(
      Localizations.localeOf(context).toString(),
    ).format(entersIntoForceOn!);
    final l10n = context.l10n;
    final message = l10n.legalPrivacyPolicyEffectiveDate(dateText);
    final messageParts = message.split(dateText);

    if (messageParts.length == 2) {
      return Text.rich(
        TextSpan(
          text: messageParts.first,
          children: [
            TextSpan(
              text: dateText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: messageParts.last),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }

    return Text(message, textAlign: TextAlign.center);
  }
}

class ChangeAppearanceButton extends StatelessWidget {
  const ChangeAppearanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextButton.icon(
      onPressed: () {
        showDisplaySettingsDialog(context);
      },
      icon: const Icon(Icons.display_settings),
      label: Text(l10n.legalChangeAppearance),
    );
  }
}

void showDisplaySettingsDialog(BuildContext context) {
  final themeSettings = Provider.of<PrivacyPolicyThemeSettings>(
    context,
    listen: false,
  );
  showDialog(
    context: context,
    builder: (context) => DisplaySettingsDialog(themeSettings: themeSettings),
  );
}

class DownloadAsPDFButton extends StatelessWidget {
  const DownloadAsPDFButton({super.key, this.enabled = true})
    : _isIconButton = false;

  const DownloadAsPDFButton.icon({super.key, this.enabled = true})
    : _isIconButton = true;

  final bool enabled;
  final bool _isIconButton;

  Future<void> downloadPdf(BuildContext context) {
    final downloadUrl = Provider.of<Uri>(context, listen: false);
    // If `mode: LaunchMode.externalApplication` isn't used then Android would
    // just show a blank page.
    return launchUrl(downloadUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _isIconButton
        ? IconButton(
          onPressed: enabled ? () => downloadPdf(context) : null,
          icon: const Icon(Icons.download),
        )
        : TextButton.icon(
          onPressed: enabled ? () => downloadPdf(context) : null,
          icon: const Icon(Icons.download),
          label: Text(l10n.legalDownloadAsPdf),
        );
  }
}

class ExpansionArrow extends StatelessWidget {
  const ExpansionArrow({
    super.key,
    required this.expansionArrowTurns,
    required this.onPressed,
  });

  final Animation<double>? expansionArrowTurns;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: expansionArrowTurns!,
      child: IconButton(
        // Without constraints the TOC section containing the button would grow
        // too large vertically.
        constraints: const BoxConstraints(maxHeight: 30),
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: const Icon(Icons.expand_more),
      ),
    );
  }
}

/// Used to highlight a TOC section if it is currently read.
class TocSectionHighlight extends StatelessWidget {
  const TocSectionHighlight({
    super.key,
    required this.child,
    required this.shouldHighlight,
    required this.onTap,
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  });

  final Widget child;
  final bool shouldHighlight;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: ShapeDecoration(
        color:
            shouldHighlight
                ? (Theme.of(context).isDarkTheme
                    ? Colors.blue.shade800
                    : Colors.lightBlue.shade100)
                : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        shape: shape,
      ),
      duration: const Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class PrivacyPolicyText extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const PrivacyPolicyText({required this.privacyPolicy, super.key});

  @override
  Widget build(BuildContext context) {
    final anchorController = Provider.of<AnchorController>(
      context,
      listen: false,
    );
    final config = Provider.of<PrivacyPolicyPageConfig>(context, listen: false);
    final theme = Provider.of<PrivacyPolicyThemeSettings>(
      context,
      listen: false,
    );
    final documentController = Provider.of<DocumentController>(
      context,
      listen: false,
    );

    return Stack(
      children: [
        RelativeAnchorsMarkdown(
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            // hyperlinks
            a: TextStyle(
              color:
                  Theme.of(context).isDarkTheme
                      ? Colors.blue.shade400
                      : Colors.blue.shade600,
            ),
            h3: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            blockquoteDecoration: BoxDecoration(
              color:
                  Theme.of(context).isDarkTheme
                      ? Colors.blue.shade800.withValues(alpha: .6)
                      : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          extensionSet: sharezoneMarkdownExtensionSet,
          anchorController: anchorController,
          data:
              privacyPolicy.markdownText +
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
        if (theme.showDebugThresholdIndicator!)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter
                // We have to multiply the [config.threshold] position with
                // two so that it lines up with the real threshold on
                // screen. I have absolutely no clue why though. If you dear
                // reader know why then please replace this comment.
                .add(Alignment(0, config.threshold.position * 2)),
                child: const Divider(
                  color: Colors.red,
                  thickness: 2,
                  height: 0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class OpenTocBottomSheetButton extends StatelessWidget {
  const OpenTocBottomSheetButton({this.enabled = true})
    : super(key: const ValueKey('open-toc-bottom-sheet-button-E2E'));

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: TextButton(
        onPressed:
            enabled
                ? () {
                  showTableOfContentsBottomSheet(context);
                }
                : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text(l10n.legalTableOfContents), Icon(Icons.expand_less)],
        ),
      ),
    );
  }
}

extension PrivacyPolicyVisualDensity on BuildContext {
  VisualDensity get ppVisualDensity =>
      watch<PrivacyPolicyThemeSettings>().visualDensitySetting.visualDensity;
}
