// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../privacy_policy_src.dart';

/// A chunk of text that is added to the end of the privacy policy.
///
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
/// [Markdown] widget internally to render the markdown text.
/// A [ScrollablePositionedList] internally uses two [ScrollController] that it
/// doesn't expose to the outside world:
/// https://github.com/google/flutter.widgets/issues/235
///
/// If the issue is fixed please remove the workaround that was used since its
/// a good chunk of unnecessary complexity.
class PrivacyPolicyEndSection {
  final String sectionName;
  DocumentSectionId get sectionId =>
      DocumentSectionId(generateAnchorHash(sectionName));
  final String Function(PrivacyPolicy privacyPolicy) generateMarkdown;

  const PrivacyPolicyEndSection({
    required this.sectionName,
    required this.generateMarkdown,
  });

  factory PrivacyPolicyEndSection.metadata({Locale? locale}) {
    final resolvedLocale = _resolveLocale(locale);
    final localizations = lookupSharezoneLocalizations(resolvedLocale);
    final dateFormat = DateFormat.yMd(resolvedLocale.toString());
    return PrivacyPolicyEndSection(
      sectionName: localizations.legalMetadataTitle,
      generateMarkdown:
          (privacyPolicy) => '''


---

##### ${localizations.legalMetadataTitle}
${localizations.legalMetadataVersion(privacyPolicy.version)}

${localizations.legalMetadataLastUpdated(dateFormat.format(privacyPolicy.lastChanged))}
''',
    );
  }
}

Locale _resolveLocale(Locale? locale) {
  if (locale != null) {
    return locale;
  }

  final rawLocale = Intl.getCurrentLocale();
  final normalized = rawLocale.replaceAll('-', '_');
  final parts = normalized.split('_');
  if (parts.isEmpty || parts.first.isEmpty) {
    return const Locale('de');
  }
  if (parts.length == 1) {
    return Locale(parts.first);
  }
  return Locale(parts.first, parts[1]);
}
