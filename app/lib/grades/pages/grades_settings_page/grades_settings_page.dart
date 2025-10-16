// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GradesSettingsPage extends StatelessWidget {
  const GradesSettingsPage({super.key});

  static const tag = 'grades-settings-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noten-Einstellungen')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: SafeArea(child: MaxWidthConstraintBox(child: _SettingsList())),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_SubjectsTile()],
    );
  }
}

class _SubjectsTile extends StatelessWidget {
  const _SubjectsTile();

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      leading: const Icon(Icons.menu_book_outlined),
      title: const Text('Fächer'),
      subtitle: const Text('Verwalte Fächer und verbundene Kurse'),
      onTap: () => Navigator.pushNamed(context, SubjectsPage.tag),
    );
  }
}
