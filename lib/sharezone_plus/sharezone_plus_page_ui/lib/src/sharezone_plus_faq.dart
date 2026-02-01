// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class SharezonePlusFaq extends StatelessWidget {
  const SharezonePlusFaq({super.key, this.showContentCreatorQuestion = false});

  final bool showContentCreatorQuestion;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Column(
        children: [
          const _WhoIsBehindSharezone(),
          const SizedBox(height: 12),
          const _IsSharezoneOpenSource(),
          const SizedBox(height: 12),
          const _DoAlsoGroupMemberGetPlus(),
          const SizedBox(height: 12),
          const _DoesTheFileStorageLimitAlsoForGroups(),
          const SizedBox(height: 12),
          const _SchoolClassLicense(),
          const SizedBox(height: 12),
          const _FamilyLicense(),
          if (showContentCreatorQuestion) ...[
            const SizedBox(height: 12),
            const _ContentCreator(),
          ],
        ],
      ),
    );
  }
}

class _WhoIsBehindSharezone extends StatelessWidget {
  const _WhoIsBehindSharezone();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqWhoIsBehindTitle),
      body: Text(context.l10n.sharezonePlusFaqWhoIsBehindContent),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _IsSharezoneOpenSource extends StatelessWidget {
  const _IsSharezoneOpenSource();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqOpenSourceTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.sharezonePlusFaqOpenSourceContent),
          const SizedBox(height: 12),
          Link(
            uri: Uri.parse('https://sharezone.net/github'),
            builder:
                (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Text(
                    'https://github.com/SharezoneApp/sharezone-app',
                    style: TextStyle(
                      color:
                          Theme.of(context).isDarkTheme
                              ? Theme.of(context).colorScheme.primary
                              : darkPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
          ),
        ],
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _DoAlsoGroupMemberGetPlus extends StatelessWidget {
  const _DoAlsoGroupMemberGetPlus();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqGroupMembersTitle),
      body: Text(context.l10n.sharezonePlusFaqGroupMembersContent),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _DoesTheFileStorageLimitAlsoForGroups extends StatelessWidget {
  const _DoesTheFileStorageLimitAlsoForGroups();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqStorageTitle),
      body: Text(context.l10n.sharezonePlusFaqStorageContent),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _SchoolClassLicense extends StatelessWidget {
  const _SchoolClassLicense();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqSchoolLicenseTitle),
      body: MarkdownBody(
        data: context.l10n.sharezonePlusFaqSchoolLicenseContent,
        styleSheet: MarkdownStyleSheet(
          a: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) async {
          try {
            final uri = Uri.parse(href!);
            await launchUrl(uri);
          } on Exception catch (_) {
            if (!context.mounted) return;
            showSnackSec(
              text: context.l10n.sharezonePlusFaqEmailSnackBar('plus@sharezone.net'),
              context: context,
            );
          }
        },
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _FamilyLicense extends StatelessWidget {
  const _FamilyLicense();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqFamilyLicenseTitle),
      body: MarkdownBody(
        data: context.l10n.sharezonePlusFaqFamilyLicenseContent,
        styleSheet: MarkdownStyleSheet(
          a: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) async {
          try {
            final uri = Uri.parse(href!);
            await launchUrl(uri);
          } on Exception catch (_) {
            if (!context.mounted) return;
            showSnackSec(
              text: context.l10n.sharezonePlusFaqEmailSnackBar('plus@sharezone.net'),
              context: context,
            );
          }
        },
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _ContentCreator extends StatelessWidget {
  const _ContentCreator();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.sharezonePlusFaqContentCreatorTitle),
      body: MarkdownBody(
        data: context.l10n.sharezonePlusFaqContentCreatorContent,
        styleSheet: MarkdownStyleSheet(
          a: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) async {
          try {
            final uri = Uri.parse(href!);
            await launchUrl(uri);
          } on Exception catch (_) {
            if (!context.mounted) return;
            showSnackSec(
              text: context.l10n.sharezonePlusFaqEmailSnackBar('plus@sharezone.net'),
              context: context,
            );
          }
        },
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}
