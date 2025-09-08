// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const tag = 'language';

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<AppLocaleProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.languagePageTitle)),
      body: RadioGroup(
        groupValue: localeProvider.locale,
        onChanged: (value) {
          if (value == null) return;
          localeProvider.locale = value;
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children:
              AppLocale.values.map((locale) => _LanguageTile(locale)).toList(),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile(this.locale);

  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        child: RadioListTile<AppLocale>(
          title: Text(locale.getNativeName(context)),
          subtitle:
              locale.isSystem()
                  ? null
                  : Text(locale.getTranslatedName(context)),
          value: locale,
        ),
      ),
    );
  }
}
