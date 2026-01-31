// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = _currentAppLocale(context);
    return PopupMenuButton<AppLocale>(
      tooltip: context.l10n.websiteLanguageSelectorTooltip,
      borderRadius: BorderRadius.circular(30),
      initialValue: currentLocale,
      onSelected: (locale) => _setLocale(context, locale),
      itemBuilder: (context) {
        return [
          for (final locale in _availableLocales())
            PopupMenuItem(
              value: locale,
              child: Text(
                '${locale.getTextEmoji()} ${locale.getTranslatedName(context)}',
              ),
            ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 6),
            Text(
              _languageLabel(context, currentLocale),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

AppLocale _currentAppLocale(BuildContext context) {
  final uri = Uri.parse(GoRouter.of(context).state.uri.toString());
  final langParam = uri.queryParameters['lang'];
  if (langParam == null || langParam.isEmpty) {
    return AppLocale.system;
  }
  return AppLocale.fromLanguageTag(langParam);
}

List<AppLocale> _availableLocales() {
  return const [AppLocale.system, AppLocale.en, AppLocale.de];
}

String _languageLabel(BuildContext context, AppLocale locale) {
  if (locale.isSystem()) {
    final resolvedCode = Localizations.localeOf(context).languageCode;
    return resolvedCode.toUpperCase();
  }
  return locale.toLocale().languageCode.toUpperCase();
}

void _setLocale(BuildContext context, AppLocale locale) {
  final currentUri = Uri.parse(GoRouter.of(context).state.uri.toString());
  final updatedQuery = Map<String, String>.from(currentUri.queryParameters);
  if (locale.isSystem()) {
    updatedQuery.remove('lang');
  } else {
    updatedQuery['lang'] = locale.name;
  }
  final updatedUri = currentUri.replace(queryParameters: updatedQuery);
  context.go(updatedUri.toString());
}
